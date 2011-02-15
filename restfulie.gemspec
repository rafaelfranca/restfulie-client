# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "restfulie/version"

Gem::Specification.new do |s|
  s.name        = "restfulie"
  s.version     = Restfulie::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Guilherme Silveira, Caue Guerra, Luis Cipriani, Everton Ribeiro, George Guimaraes, Paulo Ahagon, and many more!"]
  s.email       = %q{guilherme.silveira@caelum.com.br}
  s.homepage    = %q{http://restfulie.caelumobjects.com}
  s.summary     = %q{Hypermedia aware resource based library in ruby (client side) and ruby on rails (server side).}
  s.description = %q{restfulie}

  s.rubyforge_project = "restfulie"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
