require "rack/test"
require_relative "api"

def app
  Dummy::API
end
