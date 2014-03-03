#
# Cookbook Name:: python
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

version = node["python"]["version"]
install_path = "#{node['python']['prefix_dir']}/lib/python#{version.split(/(^\d+\.\d+)/)}"

remote_file "#{Chef::Config[:file_cache_path]}/Python-#{version}.tgz" do
  source "#{node['python']['url']}/#{version}/Python-#{version}.tgz"
  checksum node['python']['checksum']
  mode "0644"
  not_if { ::File.exists?(install_path) }
end

bash "build_and_install_python" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -xzvf Python-#{version}.tgz
    (cd Python-#{version} && ./configure #{node["python"]["configure_options"]})
    (cd Python-#{version} && make && make install)
  EOH
  not_if { ::File.exists?(install_path) }
end
