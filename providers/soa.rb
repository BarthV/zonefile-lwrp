#
# Cookbook Name:: zonefile
# provider:: soa
#

def globalttl_from_file
  zf = Zonefile.from_file(@current_resource.name)
  return zf.ttl
end

def origin_from_file
  zf = Zonefile.from_file(@current_resource.name)
  return zf.origin
end

def soa_from_file(field)
  zf = Zonefile.from_file(@current_resource.name)
  return zf.soa[field]
end

def regen_soa
  Zonefile.preserve_name(false)
  zf = Zonefile.from_file(@current_resource.name,@current_resource.origin)

  zf.@ttl = '99999'

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
  @current_resource.origin(@new_resource.origin)
  @current_resource.globalttl(@new_resource.globalttl)

  Chef::Log.info("
#{@current_resource.nameserver}
#{@current_resource.contact}
#{@current_resource.soattl}
#{@current_resource.refresh}
#{@current_resource.retrydelay}
#{@current_resource.expire}
#{@current_resource.neg_cache_ttl}
#{@current_resource.origin}
#{@current_resource.globalttl}

")

  Chef::Log.info("
test name = #{@current_resource.nameserver} == #{soa_from_file(:primary)} : #{@current_resource.nameserver == soa_from_file(:primary)}
test mail = #{@current_resource.contact} == #{soa_from_file(:email)} : #{@current_resource.contact == soa_from_file(:email)}
test soattl = #{@current_resource.soattl} == #{soa_from_file(:ttl)} : #{@current_resource.soattl == soa_from_file(:ttl)}
test refresh = #{@current_resource.refresh} == #{soa_from_file(:refresh)} : #{@current_resource.refresh == soa_from_file(:refresh)}
test retry = #{@current_resource.retrydelay} == #{soa_from_file(:retry)} : #{@current_resource.retrydelay == soa_from_file(:retry)}
test ttl =  #{@current_resource.globalttl} == #{globalttl_from_file} : #{@current_resource.globalttl == globalttl_from_file}
test origin =  #{@current_resource.origin} == #{origin_from_file} : #{@current_resource.origin == origin_from_file}
")

  if @current_resource.nameserver == soa_from_file(:primary) and
  @current_resource.contact == soa_from_file(:email) and
  @current_resource.soattl == soa_from_file(:ttl) and
  @current_resource.refresh == soa_from_file(:refresh) and
  @current_resource.retrydelay == soa_from_file(:retry) and
  @current_resource.expire == soa_from_file(:expire) and
  @current_resource.neg_cache_ttl == soa_from_file(:minimumTTL) and
  @current_resource.origin == origin_from_file and
  @current_resource.globalttl == globalttl_from_file
    @current_resource.update_serial = false
  else
    @current_resource.update_serial = true
  end
end

action :create do
  Chef::Log.info("need to update serial : #{@current_resource.update_serial}
")
  Chef::Log.info("content of the file :
--
#{regen_soa}
--")

  if @current_resource.update_serial
    file @current_resource.name do
      content regen_soa
      backup false
      owner new_resource.user
      group new_resource.group
      mode new_resource.mode
    end
  end
end

action :delete do
  #TODO
end

action :force do
  #TODO
end
