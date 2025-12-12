# frozen_string_literal: true

require_relative "test_helper"
require "tmpdir"
require "fileutils"

class GeneratorTest < Minitest::Test
  def test_style_file_has_correct_relative_path
    site = mock_site
    style_file = Jekyll::GithubCard::StyleFile.new(site, "/* test */")

    assert_equal "/assets/css/github-card.css", style_file.relative_path
  end

  def test_style_file_has_correct_name
    site = mock_site
    style_file = Jekyll::GithubCard::StyleFile.new(site, "/* test */")

    assert_equal "github-card.css", style_file.name
  end

  def test_style_file_writes_content_to_destination
    Dir.mktmpdir do |tmpdir|
      site = mock_site
      content = "/* GitHub Card CSS */"
      style_file = Jekyll::GithubCard::StyleFile.new(site, content)

      result = style_file.write(tmpdir)

      assert result
      written_path = File.join(tmpdir, "assets", "css", "github-card.css")
      assert File.exist?(written_path)
      assert_equal content, File.read(written_path)
    end
  end

  private

  def mock_site
    site = Object.new
    def site.static_files
      @static_files ||= []
    end
    site
  end
end

