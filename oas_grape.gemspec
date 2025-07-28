# frozen_string_literal: true

require_relative "lib/oas_grape/version"

Gem::Specification.new do |spec|
  spec.name = "oas_grape"
  spec.version = OasGrape::VERSION
  spec.authors = ["a-chacon"]
  spec.email = ["andres.ch@protonmail.com"]
  spec.homepage = "https://github.com/a-chacon/oas_grape"
  spec.summary = "OasGrape is a Grape extension for generating automatic interactive documentation for your Grape APIs."
  spec.description =
    "OasGrape is a Grape extension for generating automatic interactive documentation for your Grape APIs. It generates an OAS 3.1 document and displays it using RapiDoc."
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/a-chacon/oas_grape"
  spec.metadata["changelog_uri"] = "https://github.com/a-chacon/oas_grape"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib,public}/**/*", "LICENSE", "Rakefile", "README.md"]
  end

  spec.required_ruby_version = ">= 3.1"

  spec.add_dependency "oas_core", ">= 1.0.0"
end
