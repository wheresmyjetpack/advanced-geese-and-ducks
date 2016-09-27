require 'minitest/autorun'
require './test_mixins'

class RunnerStubTest < MiniTest::Test
  include RunnerInterfaceTest

  def setup
    @runner_stub = @object = ChaserTest::RunnerStub.new
  end
end


class ObtainableStubTest < MiniTest::Test
  include ObtainableInterfaceTest

  def setup
    @obtainable_stub = @object = ObtainableStub.new
  end
end


