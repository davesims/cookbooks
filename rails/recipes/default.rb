include_recipe "nginx"
include_recipe "unicorn"

gem_package "bundler"

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

