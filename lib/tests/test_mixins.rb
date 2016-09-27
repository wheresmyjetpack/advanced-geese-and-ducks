module ObtainableInterfaceTest
  def test_implements_the_obtainable_method
    assert_respond_to @object, :obtainable?
  end

  def test_implements_the_owned_by_method
    assert_respond_to @object, :owned_by
  end
end


module ObtainableTest
  include ObtainableInterfaceTest

  class RepairerStub
    def repair(obtainable)
      nil
    end
  end
end


module BreakablePartsInterfaceTest
  def test_implements_the_repair_time_method
    assert_respond_to @object, :repair_time
  end

  def test_implements_the_fixed_method
    assert_respond_to @object, :fixed
  end

  def test_implements_the_parts_method
    assert_respond_to @object, :parts
  end
end


module PlayerInterfaceTest
  def test_implements_the_score_method
    assert_respond_to @object, :score
  end

  def test_implements_the_lose_point_method
    assert_respond_to @object, :lose_point
  end

  def test_implements_the_name_method
    assert_respond_to @object, :name
  end
end


module PlayerTest
  include PlayerInterfaceTest

  def test_score_adds_one_to_points
    @object.score
    assert_equal 1, @object.points
  end

  def test_lose_point_subtracts_one_point
    @object.lose_point
    assert_equal -1, @object.points
  end
end


module ChaserInterfaceTest
  def test_implements_the_chaser_interface
    assert_respond_to @object, :catches?
  end
end


module ChaserTest
  include ChaserInterfaceTest

  class RunnerStub
    def run
      1
    end
  end

  def test_never_catches_runner_when_distracted
    @object.stub :distracted?, true do
      assert_equal false, @object.catches?(@runner_stub)
    end
  end
end


module RunnerInterfaceTest
  def test_implements_the_run_method
    assert_respond_to @object, :run
  end
end


module ObtainerInterfaceTest
  def test_implements_the_obtain_method
    assert_respond_to @object, :obtain
  end
end


class ObtainableStub
  def name
    'name'
  end

  def owned_by(name)
    nil
  end

  def obtainable?
    true
  end

  def repair_time
    1
  end
end


module ObtainerTest
  include ObtainerInterfaceTest

  def test_notifies_obtainable_of_ownership_when_obtained
    obtainable_mock = MiniTest::Mock.new
    def obtainable_mock.obtainable?
      true
    end
    obtainable_mock.expect :owned_by, nil, [@object.name]
    @object.obtain(obtainable_mock)
    obtainable_mock.verify
  end

  def test_obtain_sets_the_obtainable_instance_var
    @object.obtain(@obtainable_stub)
    assert_same @obtainable_stub, @object.obtainable
  end
end
