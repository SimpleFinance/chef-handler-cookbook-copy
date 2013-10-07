# ChefCookbookCopy handler
Copies your cookbooks directory to another location at the end of a Chef run.
Particularly useful for multi-step AMI builds where Chef data might be on
ephemeral storage between steps.

## Usage
Either just pull the handler file into a files directory of one of your
cookbooks, or download as a Rubygem and source it that way.

```ruby
# Option 1
cookbook_file "#{node[:chef_handler][:handler_path]}/chef-handler-cookbook-copy.rb" do
  source 'chef-handler-cookbook-copy.rb'
  mode 00600
end

chef_handler 'ChefCookbookCopy' do
  source "#{node[:chef_handler][:handler_path]}/chef-handler-cookbook-copy.rb"
  action :enable
end

# Option 2
chef_gem 'chef-handler-cookbook-copy' do
  action :install
end

chef_handler 'ChefCookbookCopy' do
  source ::File.join(Gem.all_load_paths.grep(/chef-handler-cookbook-copy/).first,
                     'chef-handler-cookbook-copy.rb')
  action :enable
end
```

### Arguments
* `path` - Determines root for where to place cookbooks (default: `/var/cache/chef/cookbooks`)
* `mode` - Determines mode for `path` (default: `0755`)
* `always\_copy` - Determines whether to copy regardless of Chef run success (default: `true`)

## Author and License
Simple Finance <ops@simple.com> (##simple on Freenode)
Apache License, Version 2.0

