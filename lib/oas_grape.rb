# frozen_string_literal: true

require "oas_core"

OasCore.configure_yard!

module OasGrape
  autoload :VERSION, "oas_grape/version"
  autoload :Configuration, "oas_grape/configuration"
  autoload :RouteExtractor, "oas_grape/route_extractor"
  autoload :OasRouteBuilder, "oas_grape/oas_route_builder"

  module Web
    autoload :View, "oas_grape/web/view"
  end

  class << self
    def build
      clear_cache
      OasCore.config = config

      host_routes = RouteExtractor.host_routes
      oas_source = config.source_oas_path ? read_source_oas_file : {}

      OasCore.build(host_routes, oas_source: oas_source)
    end

    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end

    def clear_cache
      RouteExtractor.clear_cache
    end
  end
end
