package 'nginx'

service 'nginx' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

directory "/etc/nginx/sites_available" do
  mode 0644
  recursive true
  action :create
end

template "/etc/nginx/nginx.conf" do

end
