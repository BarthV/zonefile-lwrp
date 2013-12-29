# zonefile LWRP cookbook

## Description

A cookbook to manage bind zonefile SOA and global records.

All records included in zonefile are not modified at all. Only SOA record, ORIGIN and global TTL are managed by this cookbook.

## Requirements

This recipe depends on Chef 0.10.10 features, such as `chef_gem`.

## Usage

Just add this cookbook in your project metadata file.

Include the default recipe in your code to install zonefile gem dependency and bring LWRP to life :-).

`include_recipe 'zonefile'`

## LWRP

* `zonefile_soa` - configure SOA and global record for a specified zonefile. Can also create zonefile file.

### Actions

- `:create` (default): create or bind modify zonefile SOA and global variables
  to the extracted directory path
- `:force`: _not implemented yet_
- `:delete`: _not implemented yet_

### Attribute Parameters for :create

__File parameters__

- `:file` (name attribute): Required zonefile absolute path
- `:user`: file owner
  - root by default
- `:group`: file group
  - root by default
- `:mode`: file mode
  - 0644 by default

__Global zonefile parameters__

- `:origin`: zonefile global $ORIGIN option (Default is `node['fqdn']`)
- `:globalttl`: zonefile global $TTL option (Default is 4h)

__SOA parameters__

- `:nameserver`: Required SOA nameserver option
  - Default is `node['fqdn']`.
- `:contact`: Required SOA mail option
  - Default is `root.#{node['fqdn']}`
- `:soattl`: specific TTL option for SOA record
  - Default is empty
- `:refresh`: SOA refresh option
  - Default is 2h
- `:retrydelay`: SOA retry option
  - Default is 30m
- `:expire`: SOA expire option
  - Default is 1w
- `:neg_cache_ttl`: SOA minimum TTL option
  - Default is 1d

__other__

- `:no_serial_udpdate`: block all automatic serial update action
  - Default to false

### Example

    zonefile_soa '/tmp/db.zone.demo' do
      nameserver 'foo.bar.'
      contact 'root.foo.bar.'
      soattl '77777' # override default value
      refresh '124212' # no change from template
      globalttl '1234567890' #override
      origin 'foo.bar.'
    end

## Test recipe

`zonefile::test` recipe put once a zonefile in /tmp/ and modify it according to the example LWRP.

## License and Author

Author:: Barth.V ( https://github.com/BarthV )

