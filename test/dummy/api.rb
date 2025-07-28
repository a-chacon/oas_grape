require "bundler/setup"
require "oas_grape"
require "debug"
require "grape"

require_relative "./users_api"
require_relative "./notes_api"
# Step 2: Configuration for Oas - require before use OasGrape
require_relative "./oas_configuration"

module Dummy
  class API < Grape::API
    format :json

    mount Dummy::UsersAPI
    mount Dummy::NotesAPI

    # Step 2:  Mount the engine
    mount OasGrape::Web::View, at: "/docs"
  end
end
