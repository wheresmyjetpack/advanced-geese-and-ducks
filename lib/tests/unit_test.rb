require '../core'
require 'minitest/autorun'

class PartTest < MiniTest::Test
  def test_implements_the_breakable_interface
    part = Part.new(
      name: 'name',
      description: 'description',
      speed_boost: 1,
      break_chance: 0.0
    )
    assert_respond_to part, :broken?
  end

  def test_doesnt_break_with_0_precent_break_chance
    part = Part.new(
      name: 'name',
      description: 'description',
      speed_boost: 1,
      break_chance: 0.0
    )
    assert !part.broken?
  end

  def test_breaks_with_100_precent_break_chance
    part = Part.new(
      name: 'name',
      description: 'description',
      speed_boost: 1,
      break_chance: 1.0
    )
    assert part.broken?
  end
end


class PartsTest < MiniTest::Test
  class PartStub
    def speed_boost
      1
    end
  end

  class BrokenPartStub
    def broken?
      true
    end
  end

  class StablePartStub
    def broken?
      false
    end
  end

  def test_implements_the_breakables_interface
    parts = Parts.new([])
    assert_respond_to parts, :broken_parts?
  end

  def test_broken_parts_true_if_any_broken_parts
    parts = Parts.new([BrokenPartStub.new, BrokenPartStub.new, StablePartStub.new])
    assert parts.broken_parts?
  end

  def test_broken_parts_false_if_no_broken_parts
    parts = Parts.new([StablePartStub.new])
    assert !parts.broken_parts?
  end

  def test_fix_empties_the_broken_parts_array
    parts = Parts.new([BrokenPartStub.new])
    assert_empty parts.fix
  end

  def test_quality_of_parts
    parts = Parts.new([PartStub.new, PartStub.new, PartStub.new])
    assert_equal 3, parts.quality
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
