require '../core'
require 'minitest/autorun'

class PartDouble < Part
  attr_writer :break_chance
end


class PartsDouble < Parts
  attr_writer :broken_parts
end


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


class PartTest < MiniTest::Test
  def setup
    @part = PartDouble.new(
      name: 'name',
      description: 'description',
      speed_boost: 1,
      break_chance: 0.5
    )
  end

  def test_doesnt_break_with_0_precent_break_chance
    @part.break_chance = 0.0  # 0% break chance
    assert !@part.broken?
  end

  def test_breaks_with_100_precent_break_chance
    @part.break_chance = 1.0  # 100% break chance
    assert @part.broken?
  end
end


class PartsTest < MiniTest::Test
  def test_broken_parts_true_if_any_broken_parts
    parts = Parts.new([BrokenPartStub.new, BrokenPartStub.new, StablePartStub.new])
    assert parts.broken_parts?
  end

  def test_broken_parts_false_if_no_broken_parts
    parts = Parts.new([StablePartStub.new])
    assert !parts.broken_parts?
  end

  def test_fix_empties_broken_parts
    parts = PartsDouble.new([BrokenPartStub.new])
    parts.each { |p| parts.broken_parts << p }
    parts.fix
    assert_empty parts.broken_parts
  end

  def test_quality_of_parts
    parts = Parts.new([PartStub.new, PartStub.new, PartStub.new])
    assert_equal 3, parts.quality
  end
end


class BicycleTest < MiniTest::Test
  class BrokenPartsStub
    def broken_parts?
      true
    end

    def broken_parts
      [1]
    end
  end

  class IntactPartsStub
    def broken_parts?
      false
    end

    def broken_parts
      []
    end

    def quality
      0
    end
  end

  class RepairerStub
    def repair(obtainable)
      nil
    end
  end

  def setup
    @broken_bicycle = Bicycle.new(
      parts: BrokenPartsStub.new,
      repairer: RepairerStub.new
    )
    
    @stable_bicycle = Bicycle.new(
      parts: IntactPartsStub.new,
      repairer: RepairerStub.new
    )
  end
  def test_speed_is_lowered_when_parts_are_broken
    assert @broken_bicycle.speed < 0
  end

  def test_speed_between_one_and_two_when_parts_intact
    100.times do
      assert_in_delta 1, @stable_bicycle.speed, 1
    end
  end

  def test_repair_time_is_zero_when_all_parts_intact
    assert_equal 0, @stable_bicycle.repair_time
  end

  def test_repair_time_greater_than_zero_when_any_parts_broken
    assert @broken_bicycle.repair_time > 0
  end
end
