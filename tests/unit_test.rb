project_dir = File.dirname(File.expand_path("..", __FILE__))
tests_dir = File.dirname(File.expand_path(".", __FILE__))
require "#{project_dir}/lib/core"
require "#{tests_dir}/test_mixins"
require 'minitest/autorun'
require 'minitest/mock'


class PartTest < MiniTest::Test
  def setup
    @part = Part.new(name: 'name', description: 'description', speed_boost: 1, break_chance: 0.0)
  end

  def test_implements_the_breakable_interface
    assert_respond_to @part, :broken?
  end

  def test_doesnt_break_with_0_percent_break_chance
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
      @parts.broken_parts?  # populates the broken_parts array with any broken parts
      assert_empty @parts.fix
    end
  end

  def test_quality_of_parts_is_equal_to_total_part_quality
    assert_equal 1, @parts.quality
  end
end


class BicycleTest < MiniTest::Test
  include ObtainableInterfaceTest
  include BreakablePartsInterfaceTest

  def setup
    @repairer = KnowsRound::Garage.new
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

  def setup
    @repairer = KnowsRound::Garage.new
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

  def setup
    @repairer = KnowsRound::Garage.new
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


class PlayerTest < MiniTest::Test
  include PlayerInterfaceTest

  def setup
    @player = @object = Player.new(name: 'name')
  end

  def test_forces_subclasses_to_implement_default_breed
    # testing the public method "name", which sends default_breed to self
    assert_raises(NotImplementedError) { @player.name }
  end

  def test_score_adds_one_to_points
    @object.score
    assert_equal 1, @object.points
  end

  def test_lose_point_subtracts_one_point
    @object.lose_point
    assert_equal -1, @object.points
  end
end


class DuckTest < MiniTest::Test
  include PlayerInterfaceTest
  include PlayerSubclassInterfaceTest
  include ChaserTest
  include ObtainerTest

  def setup
    @runner_stub = RunnerStub.new
    @obtainable_stub = ObtainableStub.new
    @duck = @object = Duck.new(name: 'duck')
  end

  def test_always_catches_runner_when_runner_speed_is_one
    attempts = []
    50.times do
      attempts << @duck.catches?(@runner_stub)
    end
    refute_includes attempts, false
  end

  def test_never_catches_runner_when_runner_speed_is_eight
    @runner_stub.stub :run, 8 do
      attempts = []
      50.times do
        attempts << @duck.catches?(@runner_stub)
      end
      refute_includes attempts, true
    end
  end
end


class DogTest < MiniTest::Test
  include PlayerInterfaceTest
  include PlayerSubclassInterfaceTest
  include ChaserTest
  include ObtainerTest

  def setup
    @runner_stub = RunnerStub.new
    @obtainable_stub = ObtainableStub.new
    @dog = @object = Dog.new(name: 'dog')
  end

  def test_always_catches_runner_when_runner_speed_is_three_and_not_distracted
    @runner_stub.stub :run, 3 do
      attempts = []
      @dog.stub :distracted?, false do
        50.times do
          attempts << @dog.catches?(@runner_stub)
        end
      end
      refute_includes attempts, false
    end
  end

  def test_never_catches_runner_when_runner_speed_is_six_and_no_bonus_speed
    @runner_stub.stub :run, 6 do
      attempts = []
      @dog.stub :bonus_speed, 0 do
        50.times do
          attempts << @dog.catches?(@runner_stub)
        end
      end
      refute_includes attempts, true
    end
  end
end


class CatTest < MiniTest::Test
  include PlayerInterfaceTest
  include PlayerSubclassInterfaceTest
  include ChaserTest
  include ObtainerTest

  def setup
    @runner_stub = RunnerStub.new
    @obtainable_stub = ObtainableStub.new
    @cat = @object = Cat.new(name: 'cat')
  end

  def tests_always_cataches_runner_when_runner_speed_is_four_and_not_distracted
    @runner_stub.stub :run, 4 do
      attempts = []
      @cat.stub :distracted?, false do
        50.times do
          attempts << @cat.catches?(@runner_stub)
        end
      end
      refute_includes attempts, false
    end
  end

  def test_never_catches_runner_when_runner_speed_is_eight_and_no_bonus_speed
    @runner_stub.stub :run, 8 do
      attempts = []
      @cat.stub :bonus_speed, 0 do
        50.times do
          attempts << @cat.catches?(@runner_stub)
        end
      end
      refute_includes attempts, true
    end
  end
end


class GooseTest < MiniTest::Test
  include RunnerInterfaceTest

  def setup
    @goose = @object = Goose.new(name: 'honk')
  end

  def test_run_returns_at_least_5
    runs = []
    50.times do
      runs << (@goose.run >= 5)
    end
    refute_includes runs, false
  end

  def test_run_returns_no_more_than_8
    runs = []
    50.times do
      runs << (@goose.run <= 8)
    end
    refute_includes runs, false
  end
end


class GarageTest < MiniTest::Test
  include RepairerInterfaceTest

  def setup
    @garage = @object = KnowsRound::Garage.new
    @obtainable_stub = ObtainableStub.new    
  end

  def test_repair_sends_obtainable_to_repair_shop_on_current_round
    @garage.repair(@obtainable_stub)
    assert_equal KnowsRound.current_round, @garage.repair_shop[@obtainable_stub.name] 
  end

  def test_repairing_is_true_if_repairs_not_finished
    @obtainable_stub.stub :repair_time, 10 do
      @garage.repair(@obtainable_stub)
      assert_equal true, @garage.repairing?(@obtainable_stub)
    end
  end

  def test_repairing_is_false_when_repairs_are_finished
    @obtainable_stub.stub :repair_time, -1 do
      @garage.repair(@obtainable_stub)
      assert_equal false, @garage.repairing?(@obtainable_stub)
    end
  end

  def test_repairing_is_false_when_no_obtainable_being_repaired
    assert_equal false, @garage.repairing?(@obtainable_stub)
  end
end
