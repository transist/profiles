require 'rvm/capistrano'
require "bundler/capistrano"

set :application, "profiles"
set :repository,  "profiles"
set :rvm_ruby_string, 'ruby-2.0.0-p0'

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "profiles.transi.st:23"                          # Your HTTP server, Apache/etc
role :app, "profiles.transi.st:23"                          # This may be the same as your `Web` server
role :db,  "profiles.transi.st:23", :primary => true # This is where Rails migrations will run
role :db,  "profiles.transi.st:23"

set :scm, :git
set :group, 'deploy'
set :repository, 'git@github.com:transist/profiles.git'
set :deploy_via, :remote_cache
set :copy_cache, "#{deploy_to}/shared/copy_cache"

namespace :deploy do
  task :start do
    sudo '/usr/local/bin/monit -g thin start'
  end
  task :stop do
    sudo '/usr/local/bin/monit -g thin stop'
  end
  
  task :symlink_shared do
    run "ln -nfs #{shared_path}/system/images #{release_path}/public/images"
    run "ln -nfs #{shared_path}/system/javascripts #{release_path}/public/javascripts"
    run "ln -nfs #{shared_path}/system/stylesheets #{release_path}/public/stylesheets"
    
  end
  
  task :compile do
    run "cd #{release_path}; rake assets:precompile RAILS_ENV=production "
  end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    sudo '/usr/local/bin/monit -g thin restart'
  end
end

before 'bundle:install', 'deploy:symlink_shared'
after 'bundle:install', 'deploy:compile'

