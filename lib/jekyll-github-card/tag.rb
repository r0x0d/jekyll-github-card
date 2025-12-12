# frozen_string_literal: true

require "net/http"
require "json"
require "uri"
require "cgi"

module Jekyll
  module GithubCard
    class GithubRepoTag < Liquid::Tag
      GITHUB_API_URL = "https://api.github.com/repos"
      CACHE = {}

      def initialize(tag_name, markup, tokens)
        super
        @repo = markup.strip
      end

      def render(context)
        return error_card("No repository specified") if @repo.empty?

        repo_data = fetch_repo_data(@repo)
        return error_card(repo_data[:error]) if repo_data[:error]

        build_card(repo_data)
      end

      private

      def fetch_repo_data(repo)
        return CACHE[repo] if CACHE[repo]

        uri = URI.parse("#{GITHUB_API_URL}/#{repo}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.open_timeout = 5
        http.read_timeout = 5

        request = Net::HTTP::Get.new(uri.request_uri)
        request["Accept"] = "application/vnd.github.v3+json"
        request["User-Agent"] = "Jekyll-Github-Card"

        # Use GitHub token if available
        if ENV["GITHUB_TOKEN"]
          request["Authorization"] = "token #{ENV["GITHUB_TOKEN"]}"
        end

        response = http.request(request)

        if response.code == "200"
          data = JSON.parse(response.body)
          CACHE[repo] = {
            name: data["name"],
            full_name: data["full_name"],
            description: data["description"],
            html_url: data["html_url"],
            stargazers_count: data["stargazers_count"],
            forks_count: data["forks_count"],
            language: data["language"],
            owner_avatar: data["owner"]["avatar_url"],
            owner_login: data["owner"]["login"],
            open_issues_count: data["open_issues_count"],
            watchers_count: data["watchers_count"],
            default_branch: data["default_branch"]
          }
        else
          { error: "Repository '#{repo}' not found (HTTP #{response.code})" }
        end
      rescue StandardError => e
        { error: "Failed to fetch repository: #{e.message}" }
      end

      def build_card(data)
        escaped_description = CGI.escapeHTML(data[:description] || "No description available")
        escaped_full_name = CGI.escapeHTML(data[:full_name])
        escaped_language = CGI.escapeHTML(data[:language] || "")

        <<~HTML
          <div class="github-card" data-repo="#{escaped_full_name}">
            <div class="github-card-header">
              <a href="#{data[:html_url]}" target="_blank" rel="noopener noreferrer" class="github-card-link">
                <svg class="github-card-icon" viewBox="0 0 16 16" width="20" height="20" aria-hidden="true">
                  <path fill="currentColor" d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0016 8c0-4.42-3.58-8-8-8z"></path>
                </svg>
                <span class="github-card-repo-name">#{escaped_full_name}</span>
              </a>
            </div>
            <div class="github-card-body">
              <p class="github-card-description">#{escaped_description}</p>
            </div>
            <div class="github-card-footer">
              #{language_badge(escaped_language) if data[:language]}
              <div class="github-card-stats">
                <span class="github-card-stat" title="Stars">
                  <svg viewBox="0 0 16 16" width="16" height="16" aria-hidden="true">
                    <path fill="currentColor" d="M8 .25a.75.75 0 01.673.418l1.882 3.815 4.21.612a.75.75 0 01.416 1.279l-3.046 2.97.719 4.192a.75.75 0 01-1.088.791L8 12.347l-3.766 1.98a.75.75 0 01-1.088-.79l.72-4.194L.818 6.374a.75.75 0 01.416-1.28l4.21-.611L7.327.668A.75.75 0 018 .25z"></path>
                  </svg>
                  #{format_number(data[:stargazers_count])}
                </span>
                <span class="github-card-stat" title="Forks">
                  <svg viewBox="0 0 16 16" width="16" height="16" aria-hidden="true">
                    <path fill="currentColor" d="M5 3.25a.75.75 0 11-1.5 0 .75.75 0 011.5 0zm0 2.122a2.25 2.25 0 10-1.5 0v.878A2.25 2.25 0 005.75 8.5h1.5v2.128a2.251 2.251 0 101.5 0V8.5h1.5a2.25 2.25 0 002.25-2.25v-.878a2.25 2.25 0 10-1.5 0v.878a.75.75 0 01-.75.75h-4.5A.75.75 0 015 6.25v-.878zm3.75 7.378a.75.75 0 11-1.5 0 .75.75 0 011.5 0zm3-8.75a.75.75 0 100-1.5.75.75 0 000 1.5z"></path>
                  </svg>
                  #{format_number(data[:forks_count])}
                </span>
              </div>
            </div>
          </div>
        HTML
      end

      def language_badge(language)
        return "" if language.nil? || language.empty?

        color = language_color(language)
        <<~HTML
          <span class="github-card-language">
            <span class="github-card-language-dot" style="background-color: #{color}"></span>
            #{language}
          </span>
        HTML
      end

      def language_color(language)
        colors = {
          "Ruby" => "#701516",
          "JavaScript" => "#f1e05a",
          "TypeScript" => "#3178c6",
          "Python" => "#3572A5",
          "Java" => "#b07219",
          "Go" => "#00ADD8",
          "Rust" => "#dea584",
          "C" => "#555555",
          "C++" => "#f34b7d",
          "C#" => "#178600",
          "PHP" => "#4F5D95",
          "Swift" => "#F05138",
          "Kotlin" => "#A97BFF",
          "Scala" => "#c22d40",
          "Shell" => "#89e051",
          "HTML" => "#e34c26",
          "CSS" => "#563d7c",
          "Vue" => "#41b883",
          "React" => "#61dafb",
          "Elixir" => "#6e4a7e",
          "Clojure" => "#db5855",
          "Haskell" => "#5e5086",
          "Lua" => "#000080",
          "Perl" => "#0298c3",
          "R" => "#198CE7",
          "Dart" => "#00B4AB",
          "Objective-C" => "#438eff"
        }
        colors[language] || "#586069"
      end

      def format_number(num)
        return "0" if num.nil?

        if num >= 1_000_000
          formatted = (num / 1_000_000.0).round(1)
          formatted = formatted.to_i if formatted == formatted.to_i
          "#{formatted}M"
        elsif num >= 1_000
          formatted = (num / 1_000.0).round(1)
          formatted = formatted.to_i if formatted == formatted.to_i
          "#{formatted}k"
        else
          num.to_s
        end
      end

      def error_card(message)
        <<~HTML
          <div class="github-card github-card-error">
            <div class="github-card-body">
              <p class="github-card-error-message">⚠️ #{CGI.escapeHTML(message)}</p>
            </div>
          </div>
        HTML
      end
    end
  end
end

Liquid::Template.register_tag("github", Jekyll::GithubCard::GithubRepoTag)

