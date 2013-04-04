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
load 'deploy/assets'
set :scm, :git
set :group, 'deploy'
set :repository, 'git@github.com:transist/profiles.git'
set :deploy_via, :remote_cache
set :copy_cache, "#{deploy_to}/shared/copy_cache"

namespace :deploy do
  task :start do
    run "cd #{current_release} && /Users/scott/.rvm/gems/ruby-2.0.0-p0@global/bin/bundle exec thin start -C #{current_release}/config/thin.yml"
  end
  task :stop do
    run "cd #{current_release} && /Users/scott/.rvm/gems/ruby-2.0.0-p0@global/bin/bundle exec thin stop -C #{current_release}/config/thin.yml"
  end
  
  task :symlink_shared do
    run "ln -nfs #{shared_path}/system/images #{release_path}/public/images"
    run "ln -nfs #{shared_path}/system/javascripts #{release_path}/public/javascripts"
    run "ln -nfs #{shared_path}/system/stylesheets #{release_path}/public/stylesheets"
    
  end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    # sudo '/usr/local/bin/monit -g thin restart'
    stop
    start
  end
end

namespace :bundle do
  task :install do
    run "cd #{current_release} && bundle install --gemfile #{current_release}/Gemfile --path #{shared_path}/bundle --quiet --without development test"
  end
end

before 'bundle:install', 'deploy:symlink_shared'

