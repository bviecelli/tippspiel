source 'http://rubygems.org'

gem "rails",                   "~> 3.2.12"

gem "mysql2",                  "~> 0.3.11"
gem "cancan",                  "~> 1.6.9"
gem "haml-rails",              "~> 0.4.0"
gem "devise",                  "~> 2.2.3"
gem "rails3_acts_as_paranoid", "~> 0.2.5"
gem "sass",                    "~> 3.2.8"
gem "jquery-rails",            "~> 2.2.1"   # FIXME soeren 03.05.13 updaten klappt noch alles und welche jQuery Version ist dann drin?
# FIXME soeren 03.05.13 kann das jquery Zeug unter assets weg?
gem "execjs",                  "~> 1.4.0"
gem "therubyracer",            "~> 0.11.2", :platforms=>:ruby
gem "rails_admin",             "~> 0.4.7"
gem "bootstrap-sass",          "~> 2.3.1.0"
gem "newrelic_rpm",            "~> 3.6.1.88"
gem "feed-normalizer",         "~> 1.5.2"

gem "lograge",                 "~> 0.2.0"

# Wird genutzt um per https://github.com/yeah/redmine_hoptoad_server die ErrorNotifications ins Redmine zu bekommen
gem "airbrake",                "~> 3.1.12"


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "coffee-rails", "~> 3.2.2"
  gem "sass-rails",   "~> 3.2.6"
  gem "uglifier",     "~> 2.0.1"
end

group :development, :production do
  gem "passenger",  "~> 3.0.19"
end

group :development do
  gem "magic_encoding",    "~> 0.0.2"
  gem "letter_opener",     "~> 1.1.0"
  gem "better_errors",     "~> 0.8.0"    # Provides a better error page for Rails and other Rack apps
  gem "binding_of_caller", "~> 0.7.1"    # Retrieve the binding of a method's caller. Can also retrieve bindings even further up the stack.
end

# Development auch, damit Generatoren auch im DEV-Mode lauffaehig sind
group :development, :test do
  gem "rails_best_practices", "~> 1.13.4" # a code metric tool for rails projects
  gem "uberspacify", :git => "https://github.com/soemo/uberspacify.git" # FIXME soeren 19.01.13 jans wieder nutzen, wenn er meine Anpassungen drin hat
  gem "capistrano",           "~> 2.14.2"
  gem "capistrano-ext",       "~> 1.2.1"
  gem "rvm-capistrano",       "~> 1.3.0"
  gem "rspec-rails",          "~> 2.13.1"
  gem "thin",                 "~> 1.5.1"     # lokaler Dev Server
  gem "pry",                  "~> 0.9.12.1"  # binding.pry -> debugging
end

group :test do
  gem "webmock",            "~> 1.11.0"
  gem 'faker',              "~> 1.1.2"
  gem 'factory_girl_rails', "~> 4.2.1" # TODO soeren 12.01.13 update
  gem 'webrat',             '= 0.7.3' #rspec-rails 2 braucht das um in den Views have_selector zu nutzen
end