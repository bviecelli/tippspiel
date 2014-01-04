# -*- encoding : utf-8 -*-

# By default, your app will be available in the root of your Uberspace. If you
# have your own domain set up, you can configure it here
set :domain, "beta-tippspiel.soemo.org"

# Anpassen fuer jeweiliges Tunier # TODO soeren 04.01.14 was noch #50
set :database_name_suffix, "beta_em2012" # FIXME soeren 19.01.13 jahr konfigurierbar machen AUS constants.rb? oder Module?

# a name for your app, will be used for your gemset,
# databases, directories, etc.
set :application, "beta-tippspiel.soemo.org"
set :deploy_to, "/var/www/virtual/#{user}/#{application}"

# By default, uberspacify will generate a random port number for Passenger to
# listen on. This is fine, since only Apache will use it. Your app will always
# be available on port 80 and 443 from the outside. However, if you'd like to
# set this yourself, go ahead.
set :passenger_port, 26100

set :customizing_dir, "beta"
