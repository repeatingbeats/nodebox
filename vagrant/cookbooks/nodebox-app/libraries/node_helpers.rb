module NodeHelpers

  def node_installed?
    res = `#{node[:nodejs][:dir]}/bin/node -v`.include? "v#{node[:nodejs][:version]}"
    puts "xxx node installed? #{res}"
  end

  def npm_installed?
    res = File.exists?("/usr/local/bin/npm@#{node[:nodejs][:npm]}")
    puts "xxx npm installed? #{res}"
    res
  end

  def chowned_usrlocal?
    res = `stat -c %U #{node[:nodejs][:dir]}` == "#{node[:node_user]}"
    puts "xxx chowned userlocal? #{res}"
    res
  end

end

