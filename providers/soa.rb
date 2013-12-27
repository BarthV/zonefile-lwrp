#
# Cookbook Name:: zonefile
# provider:: soa
#

def soa_from_file(field)
  zf = Zonefile.from_file(@current_resource.name)
  value = zf.soa[field]
  return zf.soa[field]
end

def regen_soa
  zf = Zonefile.from_file(@current_resource.name)
  zf.soa[:primary] = @current_resource.nameserver
  zf.soa[:email] = @current_resource.contact
  zf.soa[:ttl] = @current_resource.ttl
  zf.soa[:refresh] = @current_resource.refresh
  zf.soa[:retry] = @current_resource.retry_delay
  zf.soa[:expire] = @current_resource.expire
  zf.soa[:minimumTTL] = @current_resource.neg_cache_ttl
  zf.new_serial

  return zf.output
end

def load_current_resource
  @current_resource = Chef::Resource::ZonefileSoa.new(@new_resource.name)
  @current_resource.nameserver(@new_resource.nameserver)
  @current_resource.contact(@new_resource.contact)
  @current_resource.ttl(@new_resource.ttl)
  @current_resource.refresh(@new_resource.refresh)
  @current_resource.retry_delay(@new_resource.retry_delay)
  @current_resource.expire(@new_resource.expire)
  @current_resource.neg_cache_ttl(@new_resource.neg_cache_ttl)

  Chef::Log.info("
#{@current_resource.nameserver}
#{@current_resource.contact}
#{@current_resource.ttl}
#{@current_resource.refresh}
#{@current_resource.retry_delay}
#{@current_resource.expire}
#{@current_resource.neg_cache_ttl}

")

  Chef::Log.info("
test 1 = #{@current_resource.nameserver} == #{soa_from_file(:primary)} : #{@current_resource.nameserver == soa_from_file(:primary)}
test 2 = #{@current_resource.contact} == #{soa_from_file(:email)} : #{@current_resource.contact == soa_from_file(:email)}
test 3 = #{@current_resource.ttl} == #{soa_from_file(:ttl)} : #{@current_resource.ttl == soa_from_file(:ttl)}
test 4 = #{@current_resource.refresh} == #{soa_from_file(:refresh)} : #{@current_resource.refresh == soa_from_file(:refresh)}
test 5 = #{@current_resource.retry_delay} == #{soa_from_file(:retry)} : #{@current_resource.retry_delay == soa_from_file(:retry)}
")

  if @current_resource.nameserver == soa_from_file(:primary) and
  @current_resource.contact == soa_from_file(:email) and
  @current_resource.ttl == soa_from_file(:ttl) and
  @current_resource.refresh == soa_from_file(:refresh) and
  @current_resource.retry_delay == soa_from_file(:retry) and
  @current_resource.expire == soa_from_file(:expire) and
  @current_resource.neg_cache_ttl == soa_from_file(:minimumTTL) 
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
