include_recipe "nginx"
include_recipe "unicorn"

gem_package "bundler"

common = {:name => "dentonator", :app_root => "/u/apps/dentonator"}

dirctory common[:app_root] do 
  recursive true
  owner "root"
end

dirctory common[:app_root]+"/current" do 
  owner "root"
end

%w(config log tmp socket pids).each do |dir|
  directory "#{common[:app_root]}/shared/#{dir}" do
    recursive true
    mode 0755
  end
end

