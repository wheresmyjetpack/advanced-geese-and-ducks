tests_dir = File.dirname(File.expand_path(".", __FILE__))
require 'minitest/autorun'
require "#{tests_dir}/test_mixins"
require "#{tests_dir}/stubs"

class RunnerStubTest < MiniTest::Test
  include RunnerInterfaceTest

  def setup
    @runner_stub = @object = RunnerStub.new
  end
end


class ObtainableStubTest < MiniTest::Test
  include ObtainableInterfaceTest

  def setup
    @obtainable_stub = @object = ObtainableStub.new
  end
end


class RepairerStubTest < MiniTest::Test
  include RepairerInterfaceTest

  def setup
    @repairer_stub = @object = RepairerStub.new
  end
end
