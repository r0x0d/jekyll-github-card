# frozen_string_literal: true

module Jekyll
  module GithubCard
    class StyleGenerator < Jekyll::Generator
      safe true
      priority :low

      def generate(site)
        css_content = File.read(File.join(File.dirname(__FILE__), "..", "..", "assets", "css", "github-card.css"))
        
        # Create a static file for the CSS
        site.static_files << StyleFile.new(site, css_content)
      end
    end

    class StyleFile < Jekyll::StaticFile
      def initialize(site, content)
        @site = site
        @content = content
        @relative_path = "/assets/css/github-card.css"
        @extname = ".css"
        @name = "github-card.css"
        @dir = "/assets/css"
      end

      def write(dest)
        dest_path = File.join(dest, @relative_path)
        FileUtils.mkdir_p(File.dirname(dest_path))
        File.write(dest_path, @content)
        true
      end

      def path
        @relative_path
      end

      def relative_path
        @relative_path
      end
    end
  end
end

