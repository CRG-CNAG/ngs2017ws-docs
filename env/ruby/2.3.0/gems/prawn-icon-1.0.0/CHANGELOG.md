# 1.0.0 - September 9, 2015

- *(breaking change)* Updated Octicons from v2.4.1 to v3.1.0.
- The following icons were removed:
  - `octicon-microsope`
  - `octicon-beer`
  - `octicon-split`
  - `octicon-puzzle`
  - `octicon-steps`
  - `octicon-podium`
  - `octicon-timer`
  - `octicon-hourglass`
  - all `octicon-alignment` icons
  - all `octicon-move` icons
  - all `octicon-playback` icons
  - all `octicon-jump` icons
- The following icons were added:
  - `octicon-beaker`
  - `octicon-bell`
  - `octicon-desktop-download`
  - `octicon-watch`
  - `octicon-shield`
- Updated FontAwesome from v4.3.0 to v4.4.0. See [changelog](http://fontawesome.io/icons#new).

# 0.7.1 - August 4, 2015

- Moved the internal font directory from `fonts` to `data/fonts` for consistency between Prawn-related gems [#16](https://github.com/jessedoyle/prawn-icon/issues/16).

# 0.7.0 - July 23, 2015

- Update Travis config to relax the versions of `Prawn` and `Ruby` that are tested against. See `.travis.yml` to see what versions are supported (though you shouldn't have issues with other versions).
- Implement inline_format for table icons. [#14](https://github.com/jessedoyle/prawn-icon/pull/14).
- Updated Octicons to v2.4.1. See [changelog](https://github.com/github/octicons/releases/) between versions 2.1.2 and 2.4.1.

# 0.6.4 - May 4, 2015

- [PaymentFont](http://paymentfont.io) is now supported and included in `Prawn::Icon`.

# 0.6.3 - March 4, 2015

- Relaxed Prawn runtime dependency from >= 1.3.0 to >= 1.1.0.
- Added CI tests for multiple versions of Prawn.
- Added missing `end` statement to example code in README.

# 0.6.2 - February 10, 2015

- Added this CHANGELOG.
- Added the `table_icon` method to simplify icon use in conjuction with `Prawn::Table`.
- Added a `.yardopts` file for better documentation.
- Clean `.gemspec` to increase readability.

# 0.6.1 - January 27, 2015

- Upgraded FontAwesome to `v4.3.0`.

# 0.6.0 - January 20, 2015

- Single-quoted attributes are now supported when using `inline_format: true`.
- Prawn is now specified as a runtime dependency of `prawn/icon`.

# 0.5.1 - November 2, 2014

- Bugfix for improperly cached font data.
- Added Codeclimate and Travis CI.

# 0.5.0 - October 29, 2014

- Initial public release.