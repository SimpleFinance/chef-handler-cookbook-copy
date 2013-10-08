# lib/chef-handler-cookbook-copy.rb
#
# Author: Simple Finance <ops@simple.com>
# Copyright 2013 Simple Finance Technology Corporation.
# Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Chef handler to edit MOTD with useful info after a run

require 'rubygems'
require 'chef'
require 'chef/handler'

class ChefCookbookCopy < Chef::Handler
    attr_reader :path, :mode, :always_copy

    def initialize(options = defaults)
      @path = options[:path]
      @mode = options[:mode]
      @always_copy = options[:always_copy]
    end

    def defaults
      return {
        :path => '/var/cache/chef/cookbooks',
        :mode => 0755,
        :always_copy => true
      }
    end

    def copy_cookbooks
      cookbook_paths = Array(Chef::Config[:cookbook_path])
      cookbook_paths.each_with_index do |origin, index|
        dst = ::File.join(@path, "cookbooks-#{index}")
        FileUtils.mkdir_p(dst, :mode => @mode) if !Dir.exists?(dst)
        Dir.entries(origin).sort[2..-1].each do |cookbook|
          FileUtils.cp_r(cookbook, dst)
        end
      end
    end

    def report
      if run_status.success? || @always_copy
        Chef::Log.info "Copying cookbooks to #{@path}"
        copy_cookbooks
      end
    end

end

