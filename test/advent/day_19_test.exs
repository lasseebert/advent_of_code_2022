defmodule Advent.Day19Test do
  use Advent.Test.Case

  alias Advent.Day19

  @example_input """
  Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
  Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
  """

  @puzzle_input File.read!("puzzle_inputs/day_19.txt")

  describe "part 1" do
    test "example" do
      assert Day19.part_1(@example_input) == 33
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day19.part_1(@puzzle_input) == 1418
    end
  end

  describe "part 2" do
    test "example" do
      assert Day19.part_2(@example_input) == 56 * 62
    end

    test "puzzle input" do
      assert Day19.part_2(@puzzle_input) == 4114
    end
  end
end
