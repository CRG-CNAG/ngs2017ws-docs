# -*- encoding: utf-8 -*-
require File.expand_path('../lib/prawn/svg/version', __FILE__)

spec = Gem::Specification.new do |gem|
  gem.name = 'prawn-svg'
  gem.version = Prawn::Svg::VERSION
  gem.summary = "SVG renderer for Prawn PDF library"
  gem.description = "This gem allows you to render SVG directly into a PDF using the 'prawn' gem.  Since PDF is vector-based, you'll get nice scaled graphics if you use SVG instead of an image."
  gem.has_rdoc = false
  gem.author = "Roger Nesbitt"
  gem.email = "roger@seriousorange.com"
  gem.homepage = "http://github.com/mogest/prawn-svg"
  gem.license = 'MIT'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "prawn-svg"
  gem.require_paths = ["lib"]

  gem.required_ruby_version = '>= 1.9.3'

  gem.add_runtime_dependency "prawn", ">= 0.8.4", "< 3"
  gem.add_runtime_dependency "css_parser", "~> 1.3"
  gem.add_development_dependency "rspec", "~> 3.0"
  gem.add_development_dependency "rake", "~> 10.1"
end
