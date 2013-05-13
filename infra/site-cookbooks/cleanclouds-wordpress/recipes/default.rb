
include_recipe "php"
include_recipe "php-fpm"

include_recipe "nginx"

include_recipe "mysql::server"


# Fetch wp-cli

# fetch wp-cli and make it available
# fetch from git
git "/usr/local/src/wp-cli" do
  repository "git://github.com/wp-cli/wp-cli.git"
  reference "master"
  action :checkout
  notifies :run, 'execute[fetch_composer]'
end

execute "fetch_composer" do
  action :nothing
  command "curl -sS https://getcomposer.org/installer | php"
  cwd "/usr/local/src/wp-cli"
  notifies :run, 'execute[install_with_composer]'
end

execute "install_with_composer" do
  action :nothing
  command "php composer.phar install"
  cwd "/usr/local/src/wp-cli"
end

link "/usr/local/bin/wp" do
  to "/usr/local/src/wp-cli/bin/wp"
end

# create sites for nginx to use

# Initialize sites data bag
  log "Checking for databags" do
    level :debug
  end

sites = []
begin
  sites = data_bag("sites")
rescue
  puts "Sites data bag is empty"
end

  # define an upstream to proxy requests to
  template '/etc/nginx/conf.d/php.conf' do
    source 'nginx_upstream.conf.erb'
    owner 'root'
    group 'root'
    variables(
      :upstream_path => node['php-fpm']['pool']['clean']['listen']
      )
    # notifies :reload, "service[php5-fpm]"
  end


sites.each do |name|

  site = data_bag_item("sites", name)

  log "site #{site} discovered" do
    level :debug
  end

  #  declare our sites, using the upstream we created before

  template "/etc/nginx/sites-available/#{site['host']}.conf" do
    source 'nginx_site.conf.erb'
    owner 'root'
    group 'root'
    variables(
      :site_name => site['host'],
      :root_path =>  "/var/vhost/#{site['host']}",
      :upstream_path => "php"
      )
    # notifies :reload, "service[php5-fpm]"
  end

link "/etc/nginx/sites-enabled/#{site['host']}.conf" do
  to "/etc/nginx/sites-available/#{site['host']}.conf"
end

end
