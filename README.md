# zonefile LWRP cookbook

## Description

A cookbook to manage bind zonefile SOA and global records.

All records included in zonefile are not modified at all. Only SOA record, ORIGIN and global TTL are managed by this cookbook.

## Requirements

This recipe depends on Chef 0.10.10 features, such as `chef_gem`.

## Usage

Just add this cookbook in your project metadata file to install zonefile gem dependency and bring LWRP to life :-).

`include_recipe 'zonefile'`

## LWRP

* `zonefile_soa` - configure SOA and global record for a specified zonefile. Can also create zonefile file. It keeps existing records.

### Actions

- `:create` (default): create or modify bind zonefile, set SOA and global variables to specified values. No changes on other records are applied.
- `:force`: _not implemented yet_
- `:delete`: delete zonefile

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

- `:origin`: zonefile global $ORIGIN option (Default is using `nameserver` value or `node['fqdn']` if nameserver is not specified)
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

`zonefile::test` : this recipe creates a zonefile in /tmp/ and modify it according to the example LWRP, it also creates another zonefile from scratch using default values.

## License and Author

Author:: Barth.V ( https://github.com/BarthV )

