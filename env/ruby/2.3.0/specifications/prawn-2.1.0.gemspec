# -*- encoding: utf-8 -*-
# stub: prawn 2.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "prawn"
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Gregory Brown", "Brad Ediger", "Daniel Nelson", "Jonathan Greenberg", "James Healy"]
  s.date = "2016-03-01"
  s.description = "  Prawn is a fast, tiny, and nimble PDF generator for Ruby\n"
  s.email = ["gregory.t.brown@gmail.com", "brad@bradediger.com", "dnelson@bluejade.com", "greenberg@entryway.net", "jimmy@deefa.com"]
  s.homepage = "http://prawn.majesticseacreature.com"
  s.licenses = ["PRAWN", "GPL-2.0", "GPL-3.0"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0")
  s.rubyforge_project = "prawn"
  s.rubygems_version = "2.5.1"
  s.summary = "A fast and nimble PDF generator for Ruby"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ttfunk>, ["~> 1.4.0"])
      s.add_runtime_dependency(%q<pdf-core>, ["~> 0.6.1"])
      s.add_development_dependency(%q<pdf-inspector>, ["~> 1.2.1"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 3.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<prawn-manual_builder>, [">= 0.2.0"])
      s.add_development_dependency(%q<pdf-reader>, ["~> 1.2"])
      s.add_development_dependency(%q<rubocop>, ["= 0.30.1"])
      s.add_development_dependency(%q<code_statistics>, ["= 0.2.13"])
    else
      s.add_dependency(%q<ttfunk>, ["~> 1.4.0"])
      s.add_dependency(%q<pdf-core>, ["~> 0.6.1"])
      s.add_dependency(%q<pdf-inspector>, ["~> 1.2.1"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 3.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<prawn-manual_builder>, [">= 0.2.0"])
      s.add_dependency(%q<pdf-reader>, ["~> 1.2"])
      s.add_dependency(%q<rubocop>, ["= 0.30.1"])
      s.add_dependency(%q<code_statistics>, ["= 0.2.13"])
    end
  else
    s.add_dependency(%q<ttfunk>, ["~> 1.4.0"])
    s.add_dependency(%q<pdf-core>, ["~> 0.6.1"])
    s.add_dependency(%q<pdf-inspector>, ["~> 1.2.1"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 3.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<prawn-manual_builder>, [">= 0.2.0"])
    s.add_dependency(%q<pdf-reader>, ["~> 1.2"])
    s.add_dependency(%q<rubocop>, ["= 0.30.1"])
    s.add_dependency(%q<code_statistics>, ["= 0.2.13"])
  end
end
