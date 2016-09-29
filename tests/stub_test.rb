require 'minitest/autorun'
require './test_mixins'
require './stubs'

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
