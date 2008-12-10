set :application, 'garbled'
set :repository,  'git://github.com/BenHamill/garbled.git'

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "~/apps/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
default_run_options[:pty] = true
set :deploy_via, :remote_cache

#role :app, "benhamill.com"
#role :web, "benhamill.com"
#role :db,  "benhamill.com", :primary => true
server 'benhamill.com', :app, :web, :db, :primary => true

set :user, 'hamillbd'
set :use_sudo, false