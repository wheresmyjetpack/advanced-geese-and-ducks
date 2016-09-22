require '../core'
require 'minitest/autorun'

class PartTest < MiniTest::Test
  def setup
    @part = Part.new(
      name: 'name',
      description: 'description',
      speed_boost: 1,
      break_chance: 0.0
    )
  end

  def test_implements_the_breakable_interface
    assert_respond_to @part, :broken?
  end

  def test_doesnt_break_with_0_precent_break_chance
    assert !@part.broken?
  end

  def test_breaks_with_100_precent_break_chance
    @part.stub :break_chance, 1.0 do
      assert @part.broken?
    end
  end
end


class PartsTest < MiniTest::Test
  def setup
    @part = Part.new(name: "name", description: "description", speed_boost: 1, break_chance: 0.0)
    @parts = Parts.new([@part])
  end

  def test_implements_the_breakables_interface
    assert_respond_to @parts, :broken_parts?
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


class BicycleTest < MiniTest::Test
  class RepairerStub
    def repair(obtainable)
      nil
    end
  end

  def setup
    @parts = Parts.new([])
    @bicycle = Bicycle.new(
      parts: @parts,
      repairer: RepairerStub.new
    )
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

  def test_repair_time_is_five_when_one_part_broken
    @parts.stub :num_broken_parts, 1 do
      assert_equal 5, @bicycle.repair_time
    end
  end
end
