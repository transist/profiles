set :application, "profiles"
set :repository,  "profiles"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "profiles.transi.st:23"                          # Your HTTP server, Apache/etc
role :app, "profiles.transi.st:23"                          # This may be the same as your `Web` server
role :db,  "profiles.transi.st:23", :primary => true # This is where Rails migrations will run
role :db,  "profiles.transi.st:23"

set :scm, :git
set :repository, 'git@github.com:transist/profiles.git'
# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
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
    run "cd #{release_path}; bundle install"
    run "cd #{release_path}; bundle exec rake assets:precompile"
  end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    sudo '/usr/local/bin/monit -g thin restart'
  end
end

before 'deploy:finalize_update', 'deploy:symlink_shared'

