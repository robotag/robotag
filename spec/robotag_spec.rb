require 'spec_helper'

describe Robotag do
  let(:repo) { "spec/fixtures/tweeter" }
  before do
    @robotag = Robotag.new({ repo: repo })
  end
  it "can tell if all steps matching a pattern /^.*I'm following @elom.*$/" do
    match_regex = /^.*I'm following \@elom.*$/
    actual = @robotag.tests_with_steps_that_match(match_regex)
    expected = "ASDF"
    expect(actual).to eq(expected)
  end
end