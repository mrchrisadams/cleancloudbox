


include_recipe "php"
include_recipe "php-fpm"
include_recipe "nginx"
include_recipe "mysql::server"

# TODO update to php 5.4

# create sites for nginx to use

# load a databag for the sites