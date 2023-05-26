Gem::Specification.new do |s|
  s.name        = "robotag"
  s.version     = "1.0.0"
  s.summary     = "robotag - a gem for automating organizing a Ruby Cucumber suite with tags"
  s.description = "robotag analyzes a cucumber suite. It finds Scenarios and Scenario outlines with steps that match certain patterns. It ensures that the associated scenarios or outlines contain or do not contain certain tags"
  s.authors     = ["David West"]
  s.email       = "support@robotag.xyz"
  s.files       = ["lib/robotag.rb"]
  s.homepage    =
    "https://rubygems.org/gems/robotag"
  s.license       = "MIT"

  s.add_development_dependency "rspec", "~> 3.5"
  s.add_development_dependency "rubycritic", "~> 2.9"

  s.add_runtime_dependency "cql", "~> 1.7"
end