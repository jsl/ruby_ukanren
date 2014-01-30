require 'pry'
require 'minitest/autorun'
require 'minitest/pride'

require "mocha"

require "#{File.dirname(__FILE__)}/../lib/micro_kanren"

require "#{File.dirname(__FILE__)}/test_programs"
require "#{File.dirname(__FILE__)}/test_support"
