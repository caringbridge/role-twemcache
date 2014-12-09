default['twemcache']['version'] = '2.5.0' # can also be 2.6.0
default['twemcache']['url'] = 'http://spacewalk.caringbridge.org/pub/'
default['twemcache']['source']['path'] = '/usr/local/src'
default['twemcache']['binary']['path'] = '/usr/local/bin'
# Currently the only way to change the config is via the memcachedrep.erb file.
# default['twemcache']['config']['pid'] = '/var/run/memcachedrep.pid'
# default['twemcache']['config']['memory'] = '32' # Number in MB
# default['twemcache']['config']['port'] = '11201'
# default['twemcache']['config']['user'] = 'root'
