require 'rubygems'
require 'sinatra'
require 'haml'
require 'execjs'
require 'barista'
require './app'

#set :run, false
#set :raise_errors, true

run Sinatra::Application