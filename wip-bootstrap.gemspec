# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "wip-bootstrap/version"

Gem::Specification.new do |s|
  s.name        = "wip-bootstrap"
  s.version     = WIP::Bootstrap::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Corey Innis"]
  s.email       = ["support+wip@coolerator.net"]
  s.homepage    = "http://rubygems.org/gems/wip-bootstrap"
  s.summary     = "bootstrap 'wip'"
  s.description = "bootstrap 'wip'"

  s.rubyforge_project = "wip-bootstrap"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
