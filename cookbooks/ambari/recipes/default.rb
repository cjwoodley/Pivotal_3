#
# Cookbook Name:: ambari
# Recipe:: default
#
# Copyright (C) 2015 
#
# 
#
selinux_state "Disabled" do
  action :disabled
end

execute "Disable IPtables" do
  command "sudo /etc/init.d/iptables save && sudo /etc/init.d/iptables stop && sudo /sbin/chkconfig iptables off"
  creates "/tmp/iptables_disabled"
  action :run
end

directory '/opt/sources' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

%w(
    httpd
    ntp
  ).each do |p|
  yum_package p do 
    action :install
  end
end

service 'ntpd' do
  action [:enable, :start]
end

service 'httpd' do
  action [:enable, :start]
end

yum_package 'openssl.x86_64' do 
  action :upgrade
end

bash 'install_ambari' do
  action :nothing
  user 'root'
  cwd '/opt/sources'
  code <<-EOH
    tar -xf AMBARI-1.7.1-87-centos6.tar
    cd  AMBARI-1.7.1
    ./setup_repo.sh
  EOH
end

bash 'install_PHD' do
  action :nothing
  user 'root'
  cwd '/opt/sources'
  code <<-EOH
    tar -xf PHD-3.0.0.0-249-centos6.tar
    ./PHD-3.0.0.0/setup_repo.sh
  EOH
end

bash 'install_PHDUtils' do
  action :nothing
  user 'root'
  cwd '/opt/sources'
  code <<-EOH
    tar -xf PHD-UTILS-1.1.0.20-centos6.tar
    ./PHD-UTILS-1.1.0.20/setup_repo.sh
  EOH
end



hostsfile_entry '192.168.56.200' do
  hostname  'phdambari.local.com'
  aliases   ['phdambari']
  action    :create_if_missing
end

hostsfile_entry '192.168.56.201' do
  hostname  'phds01.local.com'
  aliases   ['phds01']
  action    :create_if_missing
end

hostsfile_entry '192.168.56.202' do
  hostname  'phds02.local.com'
  aliases   ['phds02']
  action    :create_if_missing
end

yum_package 'ambari-server' do
  action :install
end