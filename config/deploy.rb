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

desc 'Creates the production database.yml up.'
task :setup_production_database_config do
  mysql_password = Capistrano::CLI.password_prompt 'Production MySQL Password:'
  
  require 'yaml'
  spec = {
    'production' => {
      'adapter' => 'mysql',
      'database' => 'benhamill_garbled_production',
      'username' => 'garbled',
      'password' => mysql_password,
      'encoding' => 'utf8',
      'pool' => 5,
      'host' => 'mysql.benhamill.dreamhosters.com'
    }
  }
  
  run "mkdir -p #{shared_path}/config"
  put spec.to_yaml, "#{shared_path}/config/database.yml"
end
after 'deploy:setup', :setup_production_database_config

desc 'Carries database.yml forward on update.'
task :copy_production_database_config do
  run "cp #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end
after 'deploy:update_code', :copy_production_database_config