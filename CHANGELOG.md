# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2025-12-12

### Added

- `{% github user/repo %}` Liquid tag for embedding GitHub repository cards
- Light and dark theme support
  - Automatic detection via `prefers-color-scheme`
  - Support for Chirpy theme's `data-mode` attribute
  - Support for `data-theme` and class-based theme switching
- Repository information display:
  - Repository name with link
  - Description
  - Primary programming language with color indicator
  - Star count (with K/M formatting)
  - Fork count (with K/M formatting)
- Error handling for missing or inaccessible repositories
- In-memory caching for API responses
- Support for GitHub token authentication
- CSS custom properties for easy theming
- Responsive design
- XSS protection via HTML escaping

## [0.1.0] - 2025-12-11

### Added

- Initial release
