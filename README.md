# The `robotag` gem

## Quickstart

with a file `my_robotagger.rb` in the directory that contains your suite in a folder `features`

`my_robotagger.rb`

```ruby
# check that all tests with steps that have /^I go to the login page$/ are tagged with @login
regex_i_care_about = /^I go to the login page$/
tag_i_care_about = '@login'
Robotag.new({ repo: "#{__dir__}/features" }).tests_with_steps_that_match(regex_i_care_about).all_have_tag?(tag_i_care_about).go!
```