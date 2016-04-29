require "sinatra/base"
# require "sinatra/reloader"
# require 'bundler/setup'
require_relative "server"
require 'pg'
require 'pry'

run Sinatra::Server

# other server?
