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
      expect(actual.map { |result| result[:self].steps.map(&:text) }.all? { |steps| steps.any? { |step| step =~ match_regex } }).to be true
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

  describe "#tag_all_with" do
    let(:tmpdir) { "robotag_preview" }
    before do
      FileUtils.rm_rf(tmpdir)
    end
    # after do
    #   FileUtils.rm_rf(tmpdir)
    # end
    it "can tag all tests matching a regex with @foo" do
      match_regex = /I visit the my tweets page/
      tag = '@foo'
      @robotag.tests_with_steps_that_match(match_regex).tag_all_with(tag).preview
      Dir.glob(tmpdir + "/**/*").filter {|path| path.include?(".feature")}.each do |feature|
        File.readlines(feature).each_with_index do |line, idx|
          if (line =~ match_regex)
            seek = idx -1
            seek_contents = File.readlines(feature)[seek]
            until seek_contents =~ /Scenario/
              seek -= 1
              seek_contents = File.readlines(feature)[seek]
            end
            seek -= 1
            actual_tags = File.readlines(feature)[seek].chomp.split(' ')
            expect(actual_tags).to include(tag)
          end
        end
      end
    end
  end

end