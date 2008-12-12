set :application, 'garbled'
set :repository,  'git://github.com/BenHamill/garbled.git'
set :deploy_to, "~/apps/#{application}"

set :scm, :git
default_run_options[:pty] = true
set :deploy_via, :remote_cache
set :branch, 'master'

#role :app, "benhamill.com"
#role :web, "benhamill.com"
#role :db,  "benhamill.com", :primary => true
server 'benhamill.dreamhosters.com', :app, :web, :db, :primary => true

set :user, 'hamillbd'
set :use_sudo, false

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
