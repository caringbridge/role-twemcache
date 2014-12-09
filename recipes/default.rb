#
# Cookbook Name:: role-twemcache
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

source_file = "twemcache-#{node['twemcache']['version']}.tar.gz"
twemcache_tar = File.join("#{node['twemcache']['source']['path']}", "#{source_file}")
twemcache_url = File.join("#{node['twemcache']['url']}", "#{source_file}")
twemcache_present = `twemcache -V 2>&1 | awk '{print $3}'`.strip
source_version = "twemcache-#{node['twemcache']['version']}"

# Installs the libevent-devel package because it is needed for the compile.
package 'libevent-devel' do
  action :install
end

# Pulls down the source file from the spacewalk server.
remote_file twemcache_tar do
  source twemcache_url
  mode '0755'
  not_if { ::File.exist?(twemcache_tar) }
end

# Unzips and untars the file.
execute 'Extract Twemcache source' do
  cwd "#{node['twemcache']['source']['path']}"
  command "tar xvzf #{source_file}"
  not_if { ::File.exist?(File.join("#{node['twemcache']['source']['path']}", "twemcache-#{node['twemcache']['version']}")) }
end

# Compiles the source code.
bash 'Build and Install Twemcache' do
  cwd File.join("#{node['twemcache']['source']['path']}", "twemcache-#{node['twemcache']['version']}")
  code <<-EOH
    ./configure &&
    make &&
    make install
  EOH
  not_if { twemcache_present == source_version }
end

# Installs the twemcache init script.
template '/etc/init.d/twemcache' do
  source 'twemcache_init.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

# Installs the memcachedrep file.
template '/etc/default/memcachedrep' do
  source 'memcachedrep.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

# Enables the twemcache service and starts twecache
service 'twemcache' do
  action [:enable, :start]
end
