# frozen_string_literal: true

require_relative "test_helper"

class VersionTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil Jekyll::GithubCard::VERSION
  end

  def test_version_is_a_string
    assert_kind_of String, Jekyll::GithubCard::VERSION
  end

  def test_version_follows_semantic_versioning
    version = Jekyll::GithubCard::VERSION
    assert_match(/\A\d+\.\d+\.\d+\z/, version)
  end
end

