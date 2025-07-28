# frozen_string_literal: true

module OasGrape
  class Configuration < OasCore::Configuration
    attr_accessor :rapidoc_theme, :source_oas_path
    attr_reader :include_mode

    def initialize
      super(info: generate_info_object)

      @include_mode = :all
      @rapidoc_theme = :rails
      @source_oas_path = nil
    end

    def include_mode=(value)
      valid_modes = %i[all with_tags explicit]
      raise ArgumentError, "include_mode must be one of #{valid_modes}" unless valid_modes.include?(value)

      @include_mode = value
    end

    def generate_info_object
      OasCore::Spec::Info.new(
        title: title,
        summary: summary,
        description: description
      )
    end

    def title
      "OasGrape"
    end

    def summary
      "OasGrape: Automatic Interactive API Documentation for Grape"
    end

    def description
      <<~DESC
        # Welcome to OasGrape

        OasGrape automatically generates interactive documentation for your Grape APIs using the OpenAPI Specification 3.1 (OAS 3.1) and displays it with a sleek UI.

        ## Getting Started

        You've successfully mounted the OasGrape engine. This default documentation is based on your routes and automatically gathered information.

        For more details, visit the official documentation: [OasCore Documentation](https://a-chacon.com/oas_core).

        ## Features

        - **Automatic OAS 3.1 Document Generation**: No manual specification required.
        - **[RapiDoc](https://github.com/rapi-doc/RapiDoc) Integration**: Interactive API exploration.
        - **Minimal Setup**: Basic documentation works out of the box.
        - **Extensible**: Customize through configuration and YARD tags.

        Explore your API documentation and enjoy the power of OasGrape!

        Any questions visit the [OasGrape GitHub Repository](https://github.com/a-chacon/oas_grape).
      DESC
    end
  end
end
