chef_gem 'zonefile'
require 'zonefile'

template '/tmp/db.zone.demo' do
  source 'test.erb'
  not_if { File.exists?('/tmp/db.zone.demo')}
end

zonefile_soa '/tmp/db.zone.demo' do
  nameserver 'foo.bar.'
  contact 'root.foo.bar.'
#  ttl '77777' # override default value
#  refresh '124212' # no change from template
#  retry_delay "20m"
end
  
