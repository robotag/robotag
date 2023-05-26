require 'spec_helper'

describe Robotag do
  let(:repo) { "spec/fixtures/tweeter" }
  before do
    @robotag = Robotag.new({ repo: repo })
  end

  describe "#tests_with_steps_that_match" do
    it "can find all tests with steps matching a pattern /^.*I'm following @elom.*$/" do
      match_regex = /^.*I'm following \@elom.*$/
      actual = @robotag.tests_with_steps_that_match(match_regex).go!
      expect(actual.map { |result| result["steps"].map(&:text) }.all? { |steps| steps.any? { |step| step =~ match_regex } }).to be true
    end
  end

  describe "#all_have_tag?" do
    it "can find the case where not all tests have a tag" do
      match_regex = /^.*I'm following \@elom.*$/
      tag = '@im_following_elom'
      actual = @robotag.tests_with_steps_that_match(match_regex).all_have_tag?(tag).go!
      expect(actual).to be false
    end
    it "can find the case where all tests have a tag" do
      match_regex = /^I visit the my tweets page$/
      tag = '@tweets'
      actual = @robotag.tests_with_steps_that_match(match_regex).all_have_tag?(tag).go!
      expect(actual).to be true
    end
  end

end