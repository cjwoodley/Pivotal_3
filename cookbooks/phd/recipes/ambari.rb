#
# Cookbook Name:: phd
# Recipe:: default
#
# Copyright (C) 2015 
#
# 
#

directory '/opt/sources' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

%w(
    httpd
  ).each do |p|
  yum_package p do 
    action :install
  end
end

service 'httpd' do
  action [:enable, :start]
end

bash 'install_ambari' do
  action :run
  user 'root'
  cwd '/opt/sources'
  code <<-EOH
    tar -xf AMBARI-1.7.1-87-centos6.tar
    cd  AMBARI-1.7.1
    ./setup_repo.sh
  EOH
  only_if { ::File.exists?("/opt/sources/AMBARI-1.7.1-87-centos6.tar") }
end

bash 'install_PHD' do
  action :run
  user 'root'
  cwd '/opt/sources'
  code <<-EOH
    tar -xf PHD-3.0.0.0-249-centos6.tar
    ./PHD-3.0.0.0/setup_repo.sh
  EOH
  only_if { ::File.exists?("/opt/sources/PHD-3.0.0.0-249-centos6.tar") }
end

bash 'install_PHDUtils' do
  action :run
  user 'root'
  cwd '/opt/sources'
  code <<-EOH
    tar -xf PHD-UTILS-1.1.0.20-centos6.tar
    ./PHD-UTILS-1.1.0.20/setup_repo.sh
  EOH
  only_if { ::File.exists?("/opt/sources/PHD-UTILS-1.1.0.20-centos6.tar") }
end

bash 'install_hawq' do
  action :run
  user 'root'
  cwd '/opt/sources'
  code <<-EOH
    tar -xf PHD-UTILS-1.1.0.20-centos6.tar
    ./PHD-UTILS-1.1.0.20/setup_repo.sh
  EOH
  only_if { ::File.exists?("/opt/sources/PHD-UTILS-1.1.0.20-centos6.tar") }
end

bash 'copy_java' do 
	action :run
	user 'root'
    cwd '/opt/sources'
     code <<-EOH
     cp jdk-7u67-linux-x64.gz /var/lib/ambari-server/resources/jdk-7u67-linux-x64.tar.gz
     cp UnlimitedJCEPolicyJDK7.zip /var/lib/ambari-server/resources/
     EOH
  not_if { ::File.exists?("/opt/sources/UnlimitedJCEPolicyJDK7.zip") }
end

yum_package 'ambari-server' do
  action :install
end