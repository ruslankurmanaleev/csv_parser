source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.1"

gem "rails", "~> 6.0.3", ">= 6.0.3.6"

gem "puma", "~> 4.1"
gem "pg", ">= 0.18", "< 2.0"

# Front
gem "slim"
gem "sass-rails", ">= 6"

# Other
gem "bootsnap", ">= 1.4.2", require: false

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem "capybara"
  gem "database_cleaner-active_record"
  gem "listen", "~> 3.2"
  gem "rspec-rails"
  gem "shoulda-matchers", "~> 4.0"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end
