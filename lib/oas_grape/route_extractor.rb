# frozen_string_literal: true

module OasGrape
  class RouteExtractor
    class << self
      def host_routes
        @host_routes ||= extract_grape_routes
      end

      def clear_cache
        @host_routes = nil
      end

      private

      def extract_grape_routes
        grape_klasses = ObjectSpace.each_object(Class).select { |klass| klass < Grape::API }
        routes = grape_klasses.flat_map(&:routes).uniq { |r| r.path + r.request_method.to_s }

        routes = routes.map { |route| OasRouteBuilder.build_from_grape_route(route) }
        filter_routes(routes)
      end

      def filter_routes(routes)
        case OasGrape.config.include_mode
        when :with_tags
          routes.select { |route| route.tags.any? }
        when :explicit
          routes.select { |route| route.tags.any? { |t| t.tag_name == "oas_include" } }
        else
          routes
        end
      end
    end
  end
end
