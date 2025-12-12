# frozen_string_literal: true

require_relative "lib/jekyll-github-card/version"

Gem::Specification.new do |spec|
  spec.name          = "jekyll-github-card"
  spec.version       = Jekyll::GithubCard::VERSION
  spec.authors       = ["Rodolfo Olivieri"]
  spec.email         = ["rodolfo.olivieri3@gmail.com"]

  spec.summary       = "A Jekyll plugin to display GitHub repository cards in your posts"
  spec.description   = "Easily embed beautiful GitHub repository cards in your Jekyll site using a simple Liquid tag. Supports light and dark themes."
  spec.homepage      = "https://github.com/r0x0d/jekyll-github-card"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end

  spec.require_paths = ["lib"]

  spec.add_dependency "jekyll", ">= 3.7", "< 5.0"
  spec.add_dependency "logger", "~> 1.5"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "webmock", "~> 3.18"
end

