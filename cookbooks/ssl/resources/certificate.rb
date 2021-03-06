#
# Cookbook Name:: ssl
# Resource:: ssl_certificate
#
# Copyright 2017, OpenStreetMap Foundation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default_action :create

property :name, String
property :domains, [String, Array], :required => true

action :create do
  node.default[:letsencrypt][:certificates][name] = {
    :domains => Array(domains)
  }

  if letsencrypt
    certificate = letsencrypt["certificate"]
    key = letsencrypt["key"]
  end

  if certificate
    file "/etc/ssl/certs/#{name}.pem" do
      owner "root"
      group "root"
      mode 0o444
      content certificate
      backup false
      manage_symlink_source false
      force_unlink true
    end

    file "/etc/ssl/private/#{name}.key" do
      owner "root"
      group "ssl-cert"
      mode 0o440
      content key
      backup false
      manage_symlink_source false
      force_unlink true
    end
  else
    template "/tmp/#{name}.ssl.cnf" do
      cookbook "ssl"
      source "ssl.cnf.erb"
      owner "root"
      group "root"
      mode 0o644
      variables :domains => Array(new_resource.domains)
      not_if do
        ::File.exist?("/etc/ssl/certs/#{new_resource.name}.pem") && ::File.exist?("/etc/ssl/private/#{new_resource.name}.key")
      end
    end

    execute "/etc/ssl/certs/#{name}.pem" do
      command "openssl req -x509 -newkey rsa:2048 -keyout /etc/ssl/private/#{new_resource.name}.key -out /etc/ssl/certs/#{new_resource.name}.pem -days 365 -nodes -config /tmp/#{new_resource.name}.ssl.cnf"
      user "root"
      group "ssl-cert"
      not_if do
        ::File.exist?("/etc/ssl/certs/#{new_resource.name}.pem") && ::File.exist?("/etc/ssl/private/#{new_resource.name}.key")
      end
    end
  end
end

action :delete do
  file "/etc/ssl/certs/#{name}.pem" do
    action :delete
  end

  file "/etc/ssl/private/#{name}.key" do
    action :delete
  end
end

def letsencrypt
  @letsencrypt ||= search(:letsencrypt, "id:#{name}").first
end
