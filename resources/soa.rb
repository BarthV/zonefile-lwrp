#
# Cookbook Name:: zonefile
# Ressource:: soa
#

actions :create, :force, :delete
default_action :create

# zonfile SOA attributes
attribute :nameserver, :kind_of => String, :required => true, :default => node['fqdn']
attribute :contact, :kind_of => String, :required => true, :default => 'root' + node['fqdn']
attribute :ttl, :kind_of => String, :default => '4h'
attribute :refresh, :kind_of => String, :default => '2h'
attribute :retry_delay, :kind_of => String, :default => '30m'
attribute :expire, :kind_of => String, :default => '1w'
attribute :neg_cache_ttl, :kind_of => String, :default => '1d'

# Files path attributes
attribute :file, :kind_of => String, :required => true, :name_attribute => true  # name_attr is filename !
attribute :user, :kind_of => String, :default => 'root'
attribute :group, :kind_of => String, :default => 'root'
attribute :mode, :kind_of => String, :default => '0644'

attr_accessor :update_serial
