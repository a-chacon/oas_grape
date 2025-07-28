# frozen_string_literal: true

module OasGrape
  class OasRouteBuilder
    def self.build_from_grape_route(grape_route)
      new(grape_route).build
    end

    def initialize(grape_route)
      @grape_route = grape_route
    end

    def build
      OasCore::OasRoute.new(
        controller: controller,
        method_name: method_name,
        verb: verb,
        path: path,
        docstring: docstring,
        source_string: source_string,
        tags: tags
      )
    end

    private

    def controller
      @grape_route.options[:namespace] || "unknown"
    end

    def method_name
      @grape_route.options[:description] || "unknown"
    end

    def verb
      @grape_route.request_method.downcase
    end

    def path
      @grape_route.pattern.origin
    end

    def source_string
      "Source not available" # Not applicable in this context
    end

    def docstring
      detail = @grape_route.options.dig(:settings, :description, :detail) || @grape_route.options[:detail]
      return "Docstring not available" unless detail

      processed_lines = detail.lines.map { |line| line.sub(/^# /, "") }

      filtered_lines = processed_lines.reject do |line|
        line.include?("rubocop") || line.include?("TODO")
      end

      ::YARD::Docstring.parser.parse(filtered_lines.join).to_docstring
    rescue StandardError
      "Docstring not available"
    end

    def tags
      detail = @grape_route.options[:detail] || ""

      detail += "\n# @summary #{@grape_route.options[:description]}" if detail.empty? || !detail.include?("@summary")

      parse_tags(detail)
    end

    def parse_tags(comment)
      lines = comment.lines.map { |line| line.sub(/^# /, "") }
      ::YARD::Docstring.parser.parse(lines.join).tags
    end
  end
end
