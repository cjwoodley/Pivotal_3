#
# Cookbook Name:: Pivotal_3
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

hostsfile_entry '192.168.56.200' do
  hostname  ['phdambari.local.com','phdambari']
  action    :create_if_missing
end

hostsfile_entry '192.168.56.201' do
  hostname  ['phds01.local.com','phds01']
  action    :create_if_missing
end

hostsfile_entry '192.168.56.202' do
  hostname  ['phds02.local.com','phds02']
  action    :create_if_missing
end