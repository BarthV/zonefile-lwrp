#
# Cookbook Name:: zonefile
# provider:: soa
#

def globalttl_from_file
  begin
    zf = Zonefile.from_file(@current_resource.name)
  rescue
    return ""
  end
  return zf.ttl
end

def origin_from_file
  begin
    zf = Zonefile.from_file(@current_resource.name)
  rescue
    return ""
  end
  return zf.origin
end

def soa_from_file(field)
  begin
    zf = Zonefile.from_file(@current_resource.name)
  rescue
    return ""
  end
  return zf.soa[field]
end

def regen_soa
  Zonefile.preserve_name(false)
  begin
    zf = Zonefile.from_file(@current_resource.name,@current_resource.origin)
  rescue
    zf = Zonefile.new('',@current_resource.name,@current_resource.origin)
  end

  zf.instance_variable_set(:@ttl, @current_resource.globalttl)

  zf.soa[:primary] = @current_resource.nameserver
  zf.soa[:email] = @current_resource.contact
  zf.soa[:ttl] = @current_resource.soattl
  zf.soa[:refresh] = @current_resource.refresh
  zf.soa[:retry] = @current_resource.retrydelay
  zf.soa[:expire] = @current_resource.expire
  zf.soa[:minimumTTL] = @current_resource.neg_cache_ttl
  if !(@new_resource.no_serial_udpdate)
    zf.new_serial
  end

  return zf.output
end

def load_current_resource
  @current_resource = Chef::Resource::ZonefileSoa.new(@new_resource.name)
  @current_resource.nameserver(@new_resource.nameserver)
  @current_resource.contact(@new_resource.contact)
  @current_resource.soattl(@new_resource.soattl)
  @current_resource.refresh(@new_resource.refresh)
  @current_resource.retrydelay(@new_resource.retrydelay)
  @current_resource.expire(@new_resource.expire)
  @current_resource.neg_cache_ttl(@new_resource.neg_cache_ttl)
  @new_resource.origin.nil? ? @current_resource.origin(@new_resource.nameserver) : @current_resource.origin(@new_resource.origin) 
  @current_resource.globalttl(@new_resource.globalttl)

  @current_resource.update_needed = true
  
  if @current_resource.nameserver == soa_from_file(:primary) and 
  @current_resource.contact == soa_from_file(:email) and
  ( @current_resource.soattl == soa_from_file(:ttl) or current_resource.soattl.nil? ) and
  @current_resource.refresh == soa_from_file(:refresh) and
  @current_resource.retrydelay == soa_from_file(:retry) and
  @current_resource.expire == soa_from_file(:expire) and
  @current_resource.neg_cache_ttl == soa_from_file(:minimumTTL) and
  @current_resource.origin == origin_from_file and
  @current_resource.globalttl == globalttl_from_file
    @current_resource.update_needed = false
  end
end


action :create do
  if @current_resource.update_needed
    Chef::Log.info("Creating or Updating #{@new_resource.name} zonefile SOA items")

    file @current_resource.name do
      content regen_soa()
      backup false
      owner new_resource.user
      group new_resource.group
      mode new_resource.mode
      action :create
    end
  else
    Chef::Log.info("Not updating records for #{@new_resource.name} zonefile")
  end
end

action :delete do
  Chef::Log.info("Deleting #{@new_resource.name} zonefile")
  file @current_resource.name do
    backup false
    action :delete
  end
end

action :force do
  #TODO
end
