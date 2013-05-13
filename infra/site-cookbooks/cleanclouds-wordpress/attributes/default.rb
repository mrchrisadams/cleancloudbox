# override["apache"]["dir"] = "/etc/apache2"
default['php-fpm']['pools'] = ["clean"]

default['php-fpm']['pool']['clean']['listen'] = "127.0.0.1:9001"
default['php-fpm']['pool']['clean']['allowed_clients'] = ["127.0.0.1"]
default['php-fpm']['pool']['clean']['user'] = "www-data"
default['php-fpm']['pool']['clean']['group'] = "www-data"
default['php-fpm']['pool']['clean']['process_manager'] = "dynamic"
default['php-fpm']['pool']['clean']['max_children'] = 50
default['php-fpm']['pool']['clean']['start_servers'] = 5
default['php-fpm']['pool']['clean']['min_spare_servers'] = 5
default['php-fpm']['pool']['clean']['max_spare_servers'] = 35
default['php-fpm']['pool']['clean']['max_requests'] = 500