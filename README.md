# The `robotag` gem

## Quickstart

`Gemfile.rb`

```ruby
source "https://rubygems.org"
gem 'robotag', '~> 2.0.0'
```

with a file `my_robotagger.rb` in the directory that contains your suite in a folder `features`

`my_robotagger.rb`

```ruby
require 'robotag'
# check that all tests with steps that have /I go to the login page/ are tagged with @login
regex_i_care_about = /I go to the login page/
tag_i_care_about = '@login'
robotag = Robotag.new({ repo: "#{__dir__}/features" })
robotag.tests_with_steps_that_match(regex_i_care_about).all_have_tag?(tag_i_care_about).go!

# preview changes to add the tag @login to all tests with a step matching /I go to the login page/
robotag.tests_with_steps_that_match(regex_i_care_about).tag_all_with(tag_i_care_about).preview

# apply the changes
robotag.tests_with_steps_that_match(regex_i_care_about).tag_all_with(tag_i_care_about).go!
```