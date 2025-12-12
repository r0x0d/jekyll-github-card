# Jekyll GitHub Card

[![Gem Version](https://badge.fury.io/rb/jekyll-github-card.svg)](https://badge.fury.io/rb/jekyll-github-card)
[![Tests](https://github.com/r0x0d/jekyll-github-card/actions/workflows/test.yml/badge.svg)](https://github.com/r0x0d/jekyll-github-card/actions/workflows/test.yml)

A Jekyll plugin that allows you to embed beautiful GitHub repository cards in your posts and pages using a simple Liquid tag. Supports both light and dark themes automatically.

## Preview

### Dark Theme
![Dark Theme Preview](docs/dark-preview.png)

### Light Theme
![Light Theme Preview](docs/light-preview.png)

## Installation

Add this line to your Jekyll site's `Gemfile`:

```ruby
group :jekyll_plugins do
  gem 'jekyll-github-card'
end
```

Then execute:

```bash
bundle install
```

Or install it yourself:

```bash
gem install jekyll-github-card
```

### Add to your Jekyll configuration

Add the plugin to your `_config.yml`:

```yaml
plugins:
  - jekyll-github-card
```

### Include the CSS

Add the stylesheet to your layout (usually in `_includes/head.html` or your main layout file):

```html
<link rel="stylesheet" href="{{ '/assets/css/github-card.css' | relative_url }}">
```

Or import it in your main SCSS file:

```scss
@import "github-card";
```

## Usage

Use the `{% github %}` tag in any post or page:

```liquid
{% github facebook/react %}
```

This will render a card showing:
- Repository name with link
- Description
- Primary programming language with color indicator
- Star count
- Fork count

### Examples

```liquid
{% github microsoft/vscode %}
{% github rails/rails %}
{% github jekyll/jekyll %}
```

## Theme Support

The plugin automatically supports both light and dark themes through CSS.

### Automatic Detection

By default, the card respects the user's system preference via `prefers-color-scheme`.

### Manual Theme Control

#### For Chirpy Theme

Chirpy uses `data-mode="light"` on the HTML element for light mode. This is automatically supported:

```html
<html data-mode="light">  <!-- Light theme -->
<html>                     <!-- Dark theme (default) -->
```

#### For Other Themes

The CSS supports multiple theme conventions:

```html
<!-- Any of these will trigger light theme -->
<html data-mode="light">
<html data-theme="light">
<html class="light">
<div class="github-card light">
```

#### Force a Specific Theme

Add the `light` or `dark` class directly to the card:

```html
<div class="github-card light">...</div>
<div class="github-card dark">...</div>
```

## Configuration

### GitHub API Rate Limits

The plugin uses GitHub's public API, which has rate limits:
- **Unauthenticated**: 60 requests per hour
- **Authenticated**: 5,000 requests per hour

To increase the rate limit, set a GitHub token as an environment variable:

```bash
export GITHUB_TOKEN=your_github_token
```

For GitHub Actions or CI/CD:

```yaml
env:
  GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### Caching

The plugin caches API responses in memory during the build process to minimize API calls.

## Customization

### CSS Variables

The plugin uses CSS custom properties for easy theming:

```css
.github-card {
  --github-card-bg: #0d1117;
  --github-card-border: #30363d;
  --github-card-text: #e6edf3;
  --github-card-text-secondary: #8b949e;
  --github-card-link: #58a6ff;
  --github-card-link-hover: #79c0ff;
}
```

Override these in your own CSS to match your site's design:

```css
.github-card {
  --github-card-bg: var(--my-card-background);
  --github-card-border: var(--my-border-color);
  /* ... */
}
```

### Supported Languages

The plugin includes color mappings for 25+ popular programming languages. Unknown languages will use a default gray color.

## Development

After checking out the repo:

```bash
# Install dependencies
bundle install

# Run tests
bundle exec rake test

# Build the gem
gem build jekyll-github-card.gemspec
```

### Running Tests

```bash
bundle exec rake test
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/r0x0d/jekyll-github-card.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -am 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

