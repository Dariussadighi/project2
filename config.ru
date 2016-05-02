require "sinatra/base"
# require "sinatra/reloader"
# require 'bundler/setup'
require_relative "server"
require 'pg'
require 'pry'
require 'bcrypt'
require 'tilt/erb'
# require "redcarpet"

run Sinatra::Server

# other server?
