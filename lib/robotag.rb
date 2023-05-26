require 'cql'

class Robotag
  attr_accessor :repo

  def initialize(opts)
    self.repo = CQL::Repository.new(opts[:repo])
    self
  end
end