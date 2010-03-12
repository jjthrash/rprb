Gem::Specification.new do |s|
  s.name = %q{rprb}
  s.version = "0.1"
  s.date = %q{2006-10-11}
  s.summary = %q{Provides Ruby in RPN style, ostensibly for a dc replacement}
  s.has_rdoc = false
  s.authors = ["Jimmy Thrasher and Justin Dubs"]
  s.files = ["lib/rprb.rb", "lib/expr.rb", "bin/rprb", "test/ts_all.rb", "test/tc_evaluator.rb", "test/tc_reader.rb", "test/tc_misc.rb", "README", "LICENSE"]
  s.test_files = ["test/ts_all.rb", "test/tc_evaluator.rb", "test/tc_reader.rb", "test/tc_misc.rb"]
  s.executables = ["rprb"]
  s.add_dependency 'rockit', '>= 0.7.2'
end

# vim:ft=ruby
