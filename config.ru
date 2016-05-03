require "sinatra/base"
require_relative "server"
require 'pg'
require 'pry'
require 'bcrypt'
require 'tilt/erb'
# require "redcarpet"

run Sinatra::Server
