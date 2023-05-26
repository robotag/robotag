require 'cql'

class Robotag
  attr_accessor :repo, :chain_state

  def initialize(opts)
    self.repo = CQL::Repository.new(opts[:repo])
    self
  end

  def tests_with_steps_that_match(my_regex)
    self.chain_state = self.repo.query do
      select name, steps, tags
      from scenarios, outlines
      with { |scenario| scenario.steps.map(&:text).any? { |step| step =~ my_regex } }
    end
    self
  end

  def all_have_tag?(tag)
    self.chain_state = self.chain_state.map do |query_result|
      query_result["tags"].map do |cm_tag|
        cm_tag.map(&:name)
      end
    end.all? do |mapped_qr|
      mapped_qr.flatten.any? do |test_tag|
        test_tag == tag
      end
    end
    self
  end

  def go!
    self.chain_state
  end
end