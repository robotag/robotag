require 'cql'

class Robotag
  attr_accessor :repo, :chain_state, :write_directives

  def initialize(opts)
    self.repo = CQL::Repository.new(opts[:repo])
    self.write_directives = {}
    self
  end

  def tests_with_steps_that_match(my_regex)
    self.chain_state = self.repo.query do
      select
      from scenarios, outlines
      with { |scenario| scenario.steps.map(&:text).any? { |step| step =~ my_regex } }
    end
    self
  end

  def all_have_tag?(tag)
    self.chain_state = self.chain_state.map do |query_result|
      query_result[:self].tags.map do |cm_tag|
        cm_tag.map(&:name)
      end
    end.all? do |mapped_qr|
      mapped_qr.flatten.any? do |test_tag|
        test_tag == tag
      end
    end
    self
  end

  # This is heavily borrowed from https://raw.githubusercontent.com/enkessler/cuke_cataloger/master/lib/cuke_cataloger/unique_test_case_tagger.rb
  # Specifically it is an adapted version of #tag_tests
  def tag_all_with(tag)
    warn('This script will potentially rewrite all of your feature files. Please be patient and remember to tip your source control system.') # rubocop:disable Metrics/LineLength

    analysis_and_output(tag, :add)
    self
  end

  def remove_all(tag)
    warn('This script will potentially rewrite all of your feature files. Please be patient and remember to tip your source control system.') # rubocop:disable Metrics/LineLength

    analysis_and_output(tag, :remove)
    self
  end

  def process_tag(test, tag, action)
    if action == :add
      return if has_tag?(test, tag)
    elsif action == :remove
      return unless has_tag?(test, tag)
    end

    modify_test_tag(test, tag, action)
  end

  def modify_test_tag(test, tag, action)
    feature_file = test.get_ancestor(:feature_file)
    file_path = feature_file.path

    tag_index = (test.source_line - 2)

    file_lines = if self.write_directives[file_path].nil?
                   File.readlines(file_path)
                 else
                   self.write_directives[file_path].split("\n").map { |line| line + "\n" }
                 end

    if action == :add
      file_lines[tag_index] = "#{file_lines[tag_index].chomp} #{tag}\n"
    elsif action == :remove
      file_lines[tag_index].delete!(tag)
    end

    self.write_directives[file_path] = file_lines.join

    new_tag = CukeModeler::Tag.new
    new_tag.name = tag
    test.tags << new_tag
    self
  end

  def has_tag?(test, tag)
    test.tags.map(&:name).include?(tag)
  end

  def preview
    unless self.write_directives.empty?
      dirname = "robotag_preview"
      FileUtils.rm_rf(dirname)
      self.write_directives.each do |filepath, file_contents|
        FileUtils.mkdir_p(File.dirname("#{dirname}/#{filepath}"))
        File.open("#{dirname}/#{filepath}", 'w+') do |tmp_file|
          tmp_file.print file_contents
        end
      end
    end
  end

  def go!
    if !self.write_directives.empty?
      self.write_directives.each do |file_path, joined_file_lines|
        File.open(file_path, 'w+') { |file| file.print joined_file_lines }
      end
    else
      self.chain_state
    end
  end

  private

  def analysis_and_output(tag, action)
    self.chain_state.map { |query_result| query_result[:self] }.each do |test|
      if (test.is_a?(CukeModeler::Scenario) || test.is_a?(CukeModeler::Outline))
        process_tag(test, tag, action)
      else
        raise("Unknown test type: #{test.class}")
      end
    end
  end
end