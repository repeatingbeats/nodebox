bash "Create a shared symbolic link apt-get archive" do
	user "root"
	cwd "/tmp"
	code <<-EOH
	if [ -d "#{node[:apt_get][:archive_dir]}" ]; then 
		if [ -L "#{node[:apt_get][:archive_dir]}" ]; then
			exit 0
		else
			sudo rm -rf #{node[:apt_get][:archive_dir]}
			sudo ln -s #{node[:apt_get][:link_dir]} #{node[:apt_get][:archive_dir]}
		fi
	fi
	
	exit 0
	EOH
end