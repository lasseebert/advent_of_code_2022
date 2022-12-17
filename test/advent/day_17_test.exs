defmodule Advent.Day17Test do
  use Advent.Test.Case

  alias Advent.Day17

  @example_input """
  >>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
  """

  @puzzle_input File.read!("puzzle_inputs/day_17.txt")

  describe "part 1" do
    test "example" do
      assert Day17.part_1(@example_input) == 3068
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day17.part_1(@puzzle_input) == 3227
    end
  end

  describe "part 2" do
    test "example" do
      assert Day17.part_2(@example_input) == 1_514_285_714_288
    end

    @tag timeout: :infinity
    @tag :puzzle_input
    test "puzzle input" do
      assert Day17.part_2(@puzzle_input) == 1_597_714_285_698
    end
  end
end
