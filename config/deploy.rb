# -*- encoding : utf-8 -*-
require "bundler/capistrano"

load "config/recipes/base"
# below here, comment out the ones you don't need
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/postgresql"
load "config/recipes/rbenv"
load "config/recipes/uploads"
load "config/recipes/check"
# load "config/recipes/custom_config"

server "176.58.107.6", :web, :app, :db, primary: true
default_run_options[:pty] = true
set :application, "testcap"  # configure at least THIS...
set :user, "root"         # ...THIS...
set :domain, "176.58.107.6"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false # this may be a bit misleading, the user on the server still needs sudo-rights!

set :scm, :git
set :repository, "https://github.com/rokkit/testcap.git" # ...and THIS.
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:migrate"
after "deploy", "deploy:cleanup" # last 5 releases

# and maybe some of THIS
set :ruby_version, "2.0.0-p195"   # default 1.9.3-p194
set :use_rmagick, true            # default false
#set :use_rbenv_gemset, false      # default true
# set :newrelic_key, "???"          # required for `newrelic` and `newrelic_sysmond`
set :default_environment, {
  'RBENV_ROOT' => "$HOME/.rbenv/",
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}
#set :bundle_flags, "--quiet --binstubs --shebang ruby-local-exec"
