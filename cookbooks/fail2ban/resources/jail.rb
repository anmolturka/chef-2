#
# Cookbook Name:: fail2ban
# Resource:: fail2ban_jail
#
# Copyright 2015, OpenStreetMap Foundation
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

actions :create, :delete
default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :filter, :kind_of => String
attribute :logpath, :kind_of => String
attribute :protocol, :kind_of => String
attribute :ports, :kind_of => Array, :default => []
attribute :maxretry, :kind_of => Integer
attribute :ignoreips, :kind_of => Array

def after_created
  notifies :reload, "service[fail2ban]"
end
