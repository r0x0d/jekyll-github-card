# frozen_string_literal: true

require_relative "test_helper"

class GithubCardTagTest < Minitest::Test
  include TestHelpers

  def setup
    clear_cache
  end

  def teardown
    clear_cache
    WebMock.reset!
  end

  def test_renders_github_card_with_valid_repo
    stub_github_api("facebook/react")

    template = Liquid::Template.parse("{% github facebook/react %}")
    output = template.render

    assert_includes output, 'class="github-card"'
    assert_includes output, 'data-repo="facebook/react"'
    assert_includes output, "facebook/react"
    assert_includes output, "A declarative, efficient, and flexible JavaScript library"
    assert_includes output, "220k" # Stars formatted
    assert_includes output, "45k"  # Forks formatted
    assert_includes output, "JavaScript"
  end

  def test_renders_github_card_with_link
    stub_github_api("facebook/react")

    template = Liquid::Template.parse("{% github facebook/react %}")
    output = template.render

    assert_includes output, 'href="https://github.com/facebook/react"'
    assert_includes output, 'target="_blank"'
    assert_includes output, 'rel="noopener noreferrer"'
  end

  def test_renders_error_for_nonexistent_repo
    stub_github_api_not_found("nonexistent/repo")

    template = Liquid::Template.parse("{% github nonexistent/repo %}")
    output = template.render

    assert_includes output, 'class="github-card github-card-error"'
    assert_includes output, "Repository &#39;nonexistent/repo&#39; not found"
  end

  def test_renders_error_for_empty_repo
    template = Liquid::Template.parse("{% github %}")
    output = template.render

    assert_includes output, 'class="github-card github-card-error"'
    assert_includes output, "No repository specified"
  end

  def test_handles_network_timeout
    stub_github_api_timeout("facebook/react")

    template = Liquid::Template.parse("{% github facebook/react %}")
    output = template.render

    assert_includes output, 'class="github-card github-card-error"'
    assert_includes output, "Failed to fetch repository"
  end

  def test_caches_api_responses
    stub = stub_github_api("facebook/react")

    template = Liquid::Template.parse("{% github facebook/react %}")
    template.render
    template.render

    assert_requested stub, times: 1
  end

  def test_formats_large_star_count
    response = TestHelpers::MOCK_REPO_RESPONSE.merge("stargazers_count" => 1_500_000)
    stub_github_api("large/repo", response_body: response)

    template = Liquid::Template.parse("{% github large/repo %}")
    output = template.render

    assert_includes output, "1.5M"
  end

  def test_formats_medium_star_count
    response = TestHelpers::MOCK_REPO_RESPONSE.merge("stargazers_count" => 5_500)
    stub_github_api("medium/repo", response_body: response)

    template = Liquid::Template.parse("{% github medium/repo %}")
    output = template.render

    assert_includes output, "5.5k"
  end

  def test_formats_small_star_count
    response = TestHelpers::MOCK_REPO_RESPONSE.merge("stargazers_count" => 42)
    stub_github_api("small/repo", response_body: response)

    template = Liquid::Template.parse("{% github small/repo %}")
    output = template.render

    # Check that 42 appears in the stats (not formatted as 0.0k)
    assert_match(/>\s*42\s*</, output)
  end

  def test_handles_repo_without_language
    response = TestHelpers::MOCK_REPO_RESPONSE.merge("language" => nil)
    stub_github_api("no/language", response_body: response)

    template = Liquid::Template.parse("{% github no/language %}")
    output = template.render

    refute_includes output, 'class="github-card-language"'
  end

  def test_handles_repo_without_description
    response = TestHelpers::MOCK_REPO_RESPONSE.merge("description" => nil)
    stub_github_api("no/description", response_body: response)

    template = Liquid::Template.parse("{% github no/description %}")
    output = template.render

    assert_includes output, "No description available"
  end

  def test_escapes_html_in_description
    response = TestHelpers::MOCK_REPO_RESPONSE.merge(
      "description" => "<script>alert('xss')</script>"
    )
    stub_github_api("xss/repo", response_body: response)

    template = Liquid::Template.parse("{% github xss/repo %}")
    output = template.render

    refute_includes output, "<script>"
    assert_includes output, "&lt;script&gt;"
  end

  def test_applies_correct_language_color
    stub_github_api("facebook/react")

    template = Liquid::Template.parse("{% github facebook/react %}")
    output = template.render

    # JavaScript color
    assert_includes output, 'style="background-color: #f1e05a"'
  end

  def test_tag_strips_whitespace_from_repo_name
    stub_github_api("facebook/react")

    template = Liquid::Template.parse("{% github   facebook/react   %}")
    output = template.render

    assert_includes output, 'data-repo="facebook/react"'
  end
end

