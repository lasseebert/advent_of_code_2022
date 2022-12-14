defmodule Advent.Day14Test do
  use Advent.Test.Case

  alias Advent.Day14

  @example_input """
  498,4 -> 498,6 -> 496,6
  503,4 -> 502,4 -> 502,9 -> 494,9
  """

  @puzzle_input File.read!("puzzle_inputs/day_14.txt")

  describe "part 1" do
    test "example" do
      assert Day14.part_1(@example_input) == 24
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day14.part_1(@puzzle_input) == 1_016
    end
  end

  describe "part 2" do
    test "example" do
      assert Day14.part_2(@example_input) == 93
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day14.part_2(@puzzle_input) == 25_402
    end
  end
end
