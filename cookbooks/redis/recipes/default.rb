include_recipe "build-essential"

case node[:platform]
  when "centos","redhat","fedora"
    package "openssl-devel"
  when "debian","ubuntu"
    package "libssl-dev"
end

bash "install redis from source" do
  cwd "/usr/local/src"
  user "root"
  code <<-EOH
	wget http://redis.googlecode.com/files/redis-#{node[:redis][:version]}.tar.gz && \
	tar zxf redis-#{node[:redis][:version]}.tar.gz && \
    cd redis-#{node[:redis][:version]} && \
    make && \
    make install PREFIX=#{node[:redis][:dir]}
  EOH
  not_if do `#{node[:redis][:dir]}/bin/redis-server -v`.include? "Redis server version #{node[:redis][:version]} (00000000:0)" end

end