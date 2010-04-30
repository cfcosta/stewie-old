#!/usr/bin/env ruby
# encoding: utf-8

require './lib/autoloader'

config = ConfigParser.new

stewie = Stewie.new
stewie.set(config.options)
stewie.connect!
