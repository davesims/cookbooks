include_recipe "nginx"
include_recipe "unicorn"

gem_package "bundler"
package "rubygem-nokogiri"

common = {:name => "dentonator", :app_root => "/u/apps/dentonator"}

directory common[:app_root] do 
  recursive true
  owner "root"
  action :create
end

directory common[:app_root]+"/current" do 
  owner "root"
end

%w(config log tmp socket pids).each do |dir|
  directory "#{common[:app_root]}/shared/#{dir}" do
    recursive true
    mode 0755
  end
end

template "#{node[:unicorn][:config_path]}/#{common[:name]}.conf.rb" do
  mode 0644
  source "unicorn.conf.erb"
  variables common
end

nginx_config_path = "/etc/nginx/sites_available/#{common[:name]}.conf"

template nginx_config_path do 
  mode 0644
  source "nginx.conf.erb"
  variables common.merge(:server_names => "dentonator.com")
  notifies :reload, "service[nginx]"
end

