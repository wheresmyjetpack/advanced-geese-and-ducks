require '../core'
require 'minitest/autorun'
require 'minitest/mock'

class PartTest < MiniTest::Test
  def setup
    @part = Part.new(name: 'name', description: 'description', speed_boost: 1, break_chance: 0.0)
  end

  def test_implements_the_breakable_interface
    assert_respond_to @part, :broken?
  end

  def test_doesnt_break_with_0_precent_break_chance
    assert_equal false, @part.broken?
  end

  def test_breaks_with_100_precent_break_chance
    @part.stub :break_chance, 1.0 do
      assert_equal true, @part.broken?
    end
  end
end


class PartsTest < MiniTest::Test
  def setup
    @part = Part.new(name: "name", description: "description", speed_boost: 1, break_chance: 0.0)
    @parts = Parts.new([@part])
  end

  def test_implements_the_broken_parts_method
    assert_respond_to @parts, :broken_parts?
  end

  def test_implements_the_fix_method
    assert_respond_to @parts, :fix
  end

  def test_broken_parts_true_if_any_broken_parts
    @part.stub :broken?, true do
      assert_equal true, @parts.broken_parts?
    end
  end

  def test_broken_parts_false_if_no_broken_parts
    assert_equal false, @parts.broken_parts?
  end

  def test_fix_empties_the_broken_parts_array
    @part.stub :broken?, true do
      @parts.broken_parts?
      assert_empty @parts.fix
    end
  end

  def test_quality_of_parts_is_equal_to_total_part_quality
    assert_equal 1, @parts.quality
  end
end


module ObtainableInterfaceTest
  def test_implements_the_obtainable_interface
    assert_respond_to @object, :obtainable?
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


class BicycleTest < MiniTest::Test
  include ObtainableInterfaceTest
  include BreakablePartsInterfaceTest

  class RepairerStub
    def repair(obtainable)
      nil
    end
  end

  def setup
    @repairer = RepairerStub.new
    @parts = Parts.new([])
    @bicycle = @object = Bicycle.new(parts: @parts, repairer: @repairer)
  end

  def test_speed_is_negative_two_when_any_parts_broken
    @parts.stub :broken_parts?, true do
      assert_equal -2, @bicycle.speed
    end
  end

  def test_speed_is_either_one_or_two_when_all_parts_intact
    bicycle_speed = @bicycle.speed
    assert (bicycle_speed == 1 || bicycle_speed == 2)
  end

  def test_repair_time_is_zero_when_all_parts_intact
    assert_equal 0, @bicycle.repair_time
  end

  def test_repair_time_is_five_times_the_number_of_broken_parts
    @parts.stub :num_broken_parts, 1 do
      assert_equal 5, @bicycle.repair_time
    end
  end

  def test_bike_sends_self_to_repairer_when_any_parts_broken
    repairer = MiniTest::Mock.new
    bicycle = Bicycle.new(parts: @parts, repairer: repairer)
    repairer.expect(:repair, nil, [bicycle])
    @parts.stub :broken_parts?, true do
      bicycle.speed
    end
    repairer.verify
  end
end


class RollerbladesTest < MiniTest::Test
  include ObtainableInterfaceTest
  include BreakablePartsInterfaceTest

  class RepairerStub
    def repair(obtainable)
      nil
    end
  end

  def setup
    @repairer = RepairerStub.new
    @parts = Parts.new([])
    @rollerblades = @object = Rollerblades.new(parts: @parts, repairer: @repairer)
  end

  def test_speed_is_negative_two_when_any_parts_broken
    @parts.stub :broken_parts?, true do
      assert_equal -2, @rollerblades.speed
    end
  end

  def test_speed_is_equal_to_the_quality_of_parts_when_no_parts_broken
    @rollerblades.stub :parts_quality, 3 do
      assert_equal 3, @rollerblades.speed
    end
  end

  def test_repair_time_is_zero_when_all_parts_intact
    assert_equal 0, @rollerblades.repair_time
  end

  def test_repair_time_is_three_times_the_number_of_broken_parts
    @parts.stub :num_broken_parts, 1 do
      assert_equal 3, @rollerblades.repair_time
    end
  end

  def test_rollerblades_sends_self_to_repairer_when_any_parts_broken
    repairer = MiniTest::Mock.new
    rollerblades = Rollerblades.new(parts: @parts, repairer: repairer)
    repairer.expect(:repair, nil, [rollerblades])
    @parts.stub :broken_parts?, true do
      rollerblades.speed
    end
    repairer.verify
  end
end


class SkateboardTest < MiniTest::Test
  include ObtainableInterfaceTest
  include BreakablePartsInterfaceTest

  class RepairerStub
    def repair(obtainable)
      nil
    end
  end

  def setup
    @repairer = RepairerStub.new
    @parts = Parts.new([])
    @skateboard = @object = Skateboard.new(parts: @parts, repairer: @repairer)
  end

  def test_speed_is_negative_two_when_any_parts_broken
    @parts.stub :broken_parts?, true do
      assert_equal -2, @skateboard.speed
    end
  end

  def test_speed_is_equal_to_the_quality_of_parts_plus_one_when_no_parts_broken
    @skateboard.stub :parts_quality, 3 do
      assert_equal 4, @skateboard.speed
    end
  end

  def test_repair_time_is_zero_when_all_parts_intact
    assert_equal 0, @skateboard.repair_time
  end

  def test_repair_time_is_four_times_the_number_of_broken_parts
    @parts.stub :num_broken_parts, 1 do
      assert_equal 4, @skateboard.repair_time
    end
  end

  def test_rollerblades_sends_self_to_repairer_when_any_parts_broken
    repairer = MiniTest::Mock.new
    skateboard = Skateboard.new(parts: @parts, repairer: repairer)
    repairer.expect(:repair, nil, [skateboard])
    @parts.stub :broken_parts?, true do
      skateboard.speed
    end
    repairer.verify
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
end


module ChaserInterfaceTest
  def test_implements_the_chaser_interface
    assert_respond_to @object, :catches?
  end
end


class DuckTest < MiniTest::Test
  include PlayerInterfaceTest
  include ChaserInterfaceTest

  def setup
    @duck = @object = Duck.new(name: 'duck')
  end
end


class DogTest < MiniTest::Test
  include PlayerInterfaceTest
  include ChaserInterfaceTest

  def setup
    @dog = @object = Dog.new(name: 'dog')
  end
end


class CatTest < MiniTest::Test
  include PlayerInterfaceTest
  include ChaserInterfaceTest

  def setup
    @cat = @object = Cat.new(name: 'cat')
  end
end
