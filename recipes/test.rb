include_recipe 'zonefile::default'

template '/tmp/db.zone.demo' do
  source 'test.erb'
  not_if { File.exists?('/tmp/db.zone.demo')}
end

# modifying existing file (pushed by template)
zonefile_soa '/tmp/db.zone.demo' do
  nameserver 'foo.bar.'
  contact 'root.foo.bar.'
  soattl '77777' # override default value
  refresh '124212' # no change from template
#  retrydelay "20m"
  globalttl '1234567890' #override
  origin 'foo.bar.'
end

# creating new file
zonefile_soa '/tmp/db.test.local' do
  nameserver 'test.local.'
  contact 'root.test.local.'
  globalttl '4h'
end

