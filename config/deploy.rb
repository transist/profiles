require 'rvm/capistrano'
require "bundler/capistrano"
require 'sidekiq/capistrano'
set :bundle_cmd, '/Users/scott/.rvm/gems/ruby-1.9.3-p392@global/bin/bundle'

set :application,     "profiles"
set :repository,      "profiles"
set :rvm_ruby_string, 'ruby-1.9.3-p362'

role :web, "profiles.transi.st:23"
role :app, "profiles.transi.st:23"                         
role :db,  "profiles.transi.st:23", :primary => true
role :db,  "profiles.transi.st:23"
load 'deploy/assets'
set :scm, :git
set :group, 'deploy'
set :repository, 'git@github.com:transist/profiles.git'
set :deploy_via, :remote_cache
set :copy_cache, "#{deploy_to}/shared/copy_cache"
set :sidekiq_cmd, "#{bundle_cmd} exec sidekiq"
set :sidekiqctl_cmd, "#{bundle_cmd} exec sidekiqctl"
set :sidekiq_timeout, 10
set :sidekiq_role, :app
set :sidekiq_pid, "#{current_path}/tmp/pids/sidekiq.pid"
set :sidekiq_processes, 1

namespace :deploy do
  task :start do
    run "cd #{current_release} && #{bundle_cmd} exec thin start -C #{current_release}/config/thin.yml"
  end
  task :stop do
    run "cd #{current_release} && #{bundle_cmd} exec thin stop -C #{current_release}/config/thin.yml"
  end
  
  task :symlink_shared do
    run "ln -nfs #{shared_path}/system/images #{release_path}/public/images"
    run "ln -nfs #{shared_path}/system/javascripts #{release_path}/public/javascripts"
    run "ln -nfs #{shared_path}/system/stylesheets #{release_path}/public/stylesheets"
  end
  
  task :sweep_sidekiq_pid do
    run "if [ -d /u/apps/profiles/current ] && [ -f /u/apps/profiles/current/tmp/pids/sidekiq.pid ]; then rm /u/apps/profiles/current/tmp/pids/sidekiq.pid ; fi"
  end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_release} && #{bundle_cmd} exec thin stop -C #{current_release}/config/thin.yml"
    run "cd #{current_release} && #{bundle_cmd} exec thin start -C #{current_release}/config/thin.yml"
  end
end

namespace :bundle do
  task :install do
    run "cd #{current_release} && #{bundle_cmd} install --gemfile #{current_release}/Gemfile --path #{shared_path}/bundle --quiet --without development test"
  end
end

before 'bundle:install', 'deploy:symlink_shared'