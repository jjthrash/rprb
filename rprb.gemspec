# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rprb"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jimmy Thrasher", "Justin Dubs"]
  s.date = "2012-06-27"
  s.description = ""
  s.email = "jimmy@jimmythrasher.com"
  s.executables = ["rprb"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    "VERSION",
    "lib/expr.rb",
    "lib/rprb.rb",
    "rprb.gemspec",
    "test/tc_evaluator.rb",
    "test/tc_misc.rb",
    "test/tc_reader.rb",
    "test/ts_all.rb"
  ]
  s.homepage = "http://github.com/jjthrash/rprb"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"
  s.summary = "Provides Ruby in RPN style, ostensibly for a dc replacement"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rockit>, ["~> 0.7.2"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
    else
      s.add_dependency(%q<rockit>, ["~> 0.7.2"])
      s.add_dependency(%q<jeweler>, [">= 0"])
    end
  else
    s.add_dependency(%q<rockit>, ["~> 0.7.2"])
    s.add_dependency(%q<jeweler>, [">= 0"])
  end
end

