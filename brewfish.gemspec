# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "brewfish/version"

Gem::Specification.new do |s|
  s.name        = "brewfish"
  s.version     = Brewfish::VERSION
  s.authors     = ["Dylan Paris"]
  s.email       = ["dylan.paris+brewfish@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Roguelike Development Toolkit}
  s.description = %q{A collection of tools to assist in development of roguelikes or other console games}

  s.rubyforge_project = "brewfish"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "pry"
  s.add_development_dependency "ruby-prof"

  s.add_runtime_dependency "gosu"
end
