require 'test_helper'

class HjsonTest < Test::Unit::TestCase
  def load_fixture(name)
    File.read(File.join(__dir__, 'fixtures', name))
  end

  def load_json(name)
    JSON.parse(load_fixture("#{name}.json"))
  end

  def load_hjson(name)
    Hjson.parse(load_fixture("#{name}.hjson"))
  end

  def parse(source)
    HJson::Parser.new(source).parse
  end

  sub_test_case 'Hjson spec' do
    Dir.glob(File.join(__dir__, 'fixtures', '*_result.hjson')) do |path|
      filename = File.basename(path)
      next unless File.exist?(path.gsub(/\.hjson/, '.json'))
      basename = File.basename(filename, '.hjson')
      test filename do
        actual   = load_hjson(basename)
        expected = load_json(basename)

        pp HashDiff.diff(expected, actual) unless expected == actual

        assert { expected == actual }
      end
    end
  end

  sub_test_case 'Exception spec' do
    Dir.glob(File.join(__dir__, 'fixtures', 'fail*.hjson')) do |path|
      filename = File.basename(path)
      test(filename) { assert_raise(Hjson::SyntaxError, Hjson::EndOfInputError) { load_hjson(File.basename(filename, '.hjson')) } }
    end
  end
end
