# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cached_document/version"

Gem::Specification.new do |s|
  s.name        = "cached_document"
  s.version     = CachedDocument::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Chris Homer"]
  s.email       = ["chris@thredup.com"]
  s.homepage    = "http://github.com/chrishomer/cached_document"
  s.summary     = %q{Cached Document is used to flatten out a complex active record object and it's associations, creating an easily cachable document set.}
  s.description = %q{Cached Document is used to flatten out a complex active record object and it's associations, creating an easily cachable document set.}

  s.add_dependency("activemodel")
  s.add_dependency("memcache-client")

  s.add_development_dependency("ZenTest")
  s.add_development_dependency("rspec")

  s.rubyforge_project = "cached_document"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
