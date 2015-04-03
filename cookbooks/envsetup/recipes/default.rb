#
# Cookbook Name:: envsetup
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