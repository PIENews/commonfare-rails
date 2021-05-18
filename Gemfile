source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.3'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Frontend
gem 'bootstrap', '~> 4.0.0.beta'
gem 'jquery-rails'
gem 'font-awesome-rails'
gem 'momentjs-rails'
# Rich text by basecamp
gem 'trix'
# Select2
gem 'select2-rails'
# Embed SVGs
gem 'inline_svg'
# Graphs and charts
gem 'd3-rails'

# Nice HTML for some text
gem 'html-pipeline'
gem 'rinku'
gem 'sanitize'

# Forms
gem 'simple_form'
gem 'cocoon'
# Auth
gem 'cancancan'
gem 'devise'
gem 'devise-i18n'

gem 'geocoder'

# Localization
# No gettext since we moved to translation.io
# gem 'gettext_i18n_rails'
# gem 'gettext_i18n_rails_js', '~> 1.2.0'
gem 'translation'
gem 'i18n_data'
# From branch master to work with Rails 5
gem 'globalize', git: 'https://github.com/globalize/globalize'
gem 'activemodel-serializers-xml' # needed by globalize

# Static pages
gem 'high_voltage', '~> 3.0.0'

# Nice logs
gem 'lograge'

# Search
gem 'ransack'

# State machine
gem 'aasm'

gem 'groupdate'

# FriendlyID
gem 'friendly_id', '~> 5.2.0'
gem 'friendly_id-globalize', git: 'https://github.com/norman/friendly_id-globalize'

# Attachments
gem 'carrierwave', '~> 1.0'
gem 'mini_magick'
gem 'simple_form_fancy_uploads'

# Nice error pages
gem 'exception_handler', '~> 0.7.7.0'

# Administration
gem 'administrate'

# Piwik analytics
gem 'piwik_analytics'
gem 'autometal-piwik', require: 'piwik'

# Cookie Law
gem 'cookies_eu'

# Webpacker
gem 'webpacker'
gem 'webpacker-react'

# Social wallet
gem 'social_wallet', '~> 1.2.0'

# QR code
gem 'rqrcode'

# Notifications
gem 'activity_notification'

# PDF
gem 'prawn-svg'
gem 'prawn-rails'

# Browser's useful info
gem 'browser'

# Graphs (using a forked version)
gem 'gexf', '~> 0.0.7', git: 'https://github.com/Commonfare-net/gexf.rb.git', require: false

# Easy cron jobs
gem 'whenever'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  # Nice debug
  gem 'pry-rails'

  # Nice error page, with console
  gem 'better_errors'
  gem 'binding_of_caller'

  # Favicon as if were no tomorrow
  gem 'rails_real_favicon'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
