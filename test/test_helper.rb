# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "jekyll-github-card"
require "minitest/autorun"
require "webmock/minitest"

# Disable external connections during tests
WebMock.disable_net_connect!

module TestHelpers
  MOCK_REPO_RESPONSE = {
    "name" => "react",
    "full_name" => "facebook/react",
    "description" => "A declarative, efficient, and flexible JavaScript library for building user interfaces.",
    "html_url" => "https://github.com/facebook/react",
    "stargazers_count" => 220000,
    "forks_count" => 45000,
    "language" => "JavaScript",
    "owner" => {
      "avatar_url" => "https://avatars.githubusercontent.com/u/69631?v=4",
      "login" => "facebook"
    },
    "open_issues_count" => 1200,
    "watchers_count" => 220000,
    "default_branch" => "main"
  }.freeze

  def stub_github_api(repo, response_body: MOCK_REPO_RESPONSE, status: 200)
    stub_request(:get, "https://api.github.com/repos/#{repo}")
      .with(headers: {
              "Accept" => "application/vnd.github.v3+json",
              "User-Agent" => "Jekyll-Github-Card"
            })
      .to_return(
        status: status,
        body: response_body.is_a?(Hash) ? response_body.to_json : response_body,
        headers: { "Content-Type" => "application/json" }
      )
  end

  def stub_github_api_not_found(repo)
    stub_request(:get, "https://api.github.com/repos/#{repo}")
      .with(headers: {
              "Accept" => "application/vnd.github.v3+json",
              "User-Agent" => "Jekyll-Github-Card"
            })
      .to_return(
        status: 404,
        body: { "message" => "Not Found" }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end

  def stub_github_api_timeout(repo)
    stub_request(:get, "https://api.github.com/repos/#{repo}")
      .to_timeout
  end

  def clear_cache
    Jekyll::GithubCard::GithubRepoTag::CACHE.clear
  end
end

