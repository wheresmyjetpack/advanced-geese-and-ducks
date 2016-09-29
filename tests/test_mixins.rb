tests_dir = File.dirname(File.expand_path(".", __FILE__))
require "#{tests_dir}/stubs.rb"

module ObtainableInterfaceTest
  def test_implements_the_obtainable_method
    assert_respond_to @object, :obtainable?
  end

  def test_immplements_the_owned_by_method
    assert_respond_to @object, :owned_by
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

  def test_implements_the_obtain_method
    assert_respond_to @object, :obtain
  end

  def test_implements_the_obtain_method
    assert_respond_to @object, :obtain
  end
end


module PlayerSubclassInterfaceTest
  def test_implements_the_post_initialize_method
    assert_respond_to @object, :post_initialize
  end
end


module ChaserInterfaceTest
  def test_implements_the_chaser_interface
    assert_respond_to @object, :catches?
  end
end


module ChaserTest
  include ChaserInterfaceTest

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


module RepairerInterfaceTest
  def test_implements_the_repair_method
    assert_respond_to @object, :repair
  end

  def test_implements_the_repairing_method
    assert_respond_to @object, :repairing?
  end
end
