require "grape"

module Dummy
  class UsersAPI < Grape::API
    resource :users do
      # In-memory storage for users
      @@users = []

      desc "Returns a list of Users." do
        detail <<~OAS_GRAPE
          # @summary Returns a list of Users.
          # @parameter offset(query) [Integer] Used for pagination of response data. default: (0) minimum: (0)
          # @parameter limit(query) [Integer] Maximum number of items per page. default: (25) minimum: (1) maximum: (100)
          # @parameter status(query) [Array<String>] Filter by status. enum: (active,inactive,deleted)
          # @parameter X-front(header) [String] Header for identifying the front. minLength: (1) maxLength: (50)
          # @response Success response(200) [Array<Hash{ id: Integer}>]
          # @response_example Success(200)
          #   [ JSON
          #     [
          #       { "id": 1, "name": "John", "email": "john@example.com" },
          #       { "id": 2, "name": "Jane", "email": "jane@example.com" }
          #     ]
          #   ]
        OAS_GRAPE
      end
      get do
        { users: @@users }
      end

      desc "Creates a new User." do
        detail <<~OAS_GRAPE
          # @summary Creates a new User.
          # @request_body User details [Hash{ name: String, email: String }]
          # @request_body_example Basic User
          #   [JSON
          #     {
          #       "name": "Oas",
          #       "email": "oas@test.com"
          #     }
          #   ]
          # @response Created(201) [Hash{ user: Hash }]
          # @response_example Created(201)
          #   [JSON
          #     {
          #       "user": { "id": 1, "name": "Oas", "email": "oas@test.com" }
          #     }
          #   ]
          # @response Unprocessable Entity(422) [Hash{ errors: Array<String> }]
        OAS_GRAPE
      end
      params do
        requires :name, type: String, desc: "User name"
        requires :email, type: String, desc: "User email"
      end
      post do
        user = { id: @@users.size + 1, name: params[:name], email: params[:email] }
        @@users << user
        { user: user }
      end

      desc "Retrieves a specific User by ID." do
        detail <<~OAS_GRAPE
          # @summary Retrieves a specific User by ID.
          # @parameter id(path) [Integer] User ID. minimum: (1)
          # @response Success(200) [Hash{ user: Hash }]
          # @response_example Success(200)
          #   [JSON
          #     {
          #       "user": { "id": 1, "name": "John", "email": "john@example.com" }
          #     }
          #   ]
          # @response Not Found(404) [Hash{ error: String }]
          # @response_example Not Found(404)
          #   [JSON
          #     {
          #       "error": "User not found"
          #     }
          #   ]
        OAS_GRAPE
      end
      params do
        requires :id, type: Integer, desc: "User ID"
      end
      get ":id" do
        user = @@users.find { |u| u[:id] == params[:id].to_i }
        error!("User not found", 404) unless user
        { user: user }
      end

      desc "Updates a specific User by ID." do
        detail <<~OAS_GRAPE
          # @summary Updates a specific User by ID.
          # @parameter id(path) [Integer] User ID. minimum: (1)
          # @request_body Updated user details [Hash{ name: String, email: String }]
          # @request_body_example Updated User
          #   [JSON
          #     {
          #       "name": "Updated Name",
          #       "email": "updated@example.com"
          #     }
          #   ]
          # @response Success(200) [Hash{ user: Hash }]
          # @response_example Success(200)
          #   [JSON
          #     {
          #       "user": { "id": 1, "name": "Updated Name", "email": "updated@example.com" }
          #     }
          #   ]
          # @response Not Found(404) [Hash{ error: String }]
          # @response_example Not Found(404)
          #   [JSON
          #     {
          #       "error": "User not found"
          #     }
          #   ]
        OAS_GRAPE
      end
      params do
        requires :id, type: Integer, desc: "User ID"
        optional :name, type: String, desc: "User name"
        optional :email, type: String, desc: "User email"
      end
      put ":id" do
        user = @@users.find { |u| u[:id] == params[:id].to_i }
        error!("User not found", 404) unless user

        user[:name] = params[:name] if params[:name]
        user[:email] = params[:email] if params[:email]
        { user: user }
      end

      desc "Deletes a specific User by ID." do
        detail <<~OAS_GRAPE
          # @summary Deletes a specific User by ID.
          # @parameter id(path) [Integer] User ID. minimum: (1)
          # @response Success(200) [Hash{ message: String }]
          # @response_example Success(200)
          #   [JSON
          #     {
          #      "message": "User deleted"
          #     }
          #   ]
          # @response Not Found(404) [Hash{ error: String }]
          # @response_example Not Found(404)
          #   [JSON
          #     {
          #       "error": "User not found"
          #     }
          #   ]
        OAS_GRAPE
      end
      params do
        requires :id, type: Integer, desc: "User ID"
      end
      delete ":id" do
        user = @@users.find { |u| u[:id] == params[:id].to_i }
        error!("User not found", 404) unless user

        @@users.delete(user)
        { message: "User deleted" }
      end
    end
  end
end
