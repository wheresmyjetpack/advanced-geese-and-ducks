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
    @obrainable_stub = @object = ObtainerTest::ObtainableStub.new
  end
end

#class RepairerStubTest < MiniTest::Test

#end
