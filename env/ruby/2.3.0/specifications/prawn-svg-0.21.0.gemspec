# -*- encoding: utf-8 -*-
# stub: prawn-svg 0.21.0 ruby lib

Gem::Specification.new do |s|
  s.name = "prawn-svg"
  s.version = "0.21.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Roger Nesbitt"]
  s.date = "2015-06-24"
  s.description = "This gem allows you to render SVG directly into a PDF using the 'prawn' gem.  Since PDF is vector-based, you'll get nice scaled graphics if you use SVG instead of an image."
  s.email = "roger@seriousorange.com"
  s.homepage = "http://github.com/mogest/prawn-svg"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.5.1"
  s.summary = "SVG renderer for Prawn PDF library"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<prawn>, ["< 3", ">= 0.8.4"])
      s.add_runtime_dependency(%q<css_parser>, ["~> 1.3"])
      s.add_development_dependency(%q<rspec>, ["~> 3.0"])
      s.add_development_dependency(%q<rake>, ["~> 10.1"])
    else
      s.add_dependency(%q<prawn>, ["< 3", ">= 0.8.4"])
      s.add_dependency(%q<css_parser>, ["~> 1.3"])
      s.add_dependency(%q<rspec>, ["~> 3.0"])
      s.add_dependency(%q<rake>, ["~> 10.1"])
    end
  else
    s.add_dependency(%q<prawn>, ["< 3", ">= 0.8.4"])
    s.add_dependency(%q<css_parser>, ["~> 1.3"])
    s.add_dependency(%q<rspec>, ["~> 3.0"])
    s.add_dependency(%q<rake>, ["~> 10.1"])
  end
end
