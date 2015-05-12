#
# Cookbook Name:: phd
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

selinux_state "Disabled" do
  action :disabled
end

execute "Disable IPtables" do
  command "sudo /etc/init.d/iptables save && sudo /etc/init.d/iptables stop && sudo /sbin/chkconfig iptables off"
  creates "/tmp/iptables_disabled"
  action :run
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

hostsfile_entry '192.168.56.203' do
  hostname  'phds03.local.com'
  aliases   ['phds03']
  action    :create_if_missing
end

%w(
    ntp
  ).each do |p|
  yum_package p do 
    action :install
  end
end

service 'ntpd' do
  action [:enable, :start]
end

yum_package 'openssl.x86_64' do 
  action :upgrade
end
