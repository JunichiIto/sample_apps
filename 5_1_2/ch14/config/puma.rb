# Kernel#Integerメソッドの利用（未掲載）
# https://docs.ruby-lang.org/ja/latest/method/Kernel/m/Integer.html
# 似たような大文字で始まるメソッド(Kernel#Array)は https://qiita.com/jnchito/items/118cca7ac2f01e1ca6a0 でも紹介しています
workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/
  # deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end