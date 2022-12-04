defmodule Advent.Day04Test do
  use Advent.Test.Case

  alias Advent.Day04

  @example_input """
  2-4,6-8
  2-3,4-5
  5-7,7-9
  2-8,3-7
  6-6,4-6
  2-6,4-8
  """

  @puzzle_input File.read!("puzzle_inputs/day_04.txt")

  describe "part 1" do
    test "example" do
      assert Day04.part_1(@example_input) == 2
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day04.part_1(@puzzle_input) == 483
    end
  end

  describe "part 2" do
    test "example" do
      assert Day04.part_2(@example_input) == 4
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day04.part_2(@puzzle_input) == 874
    end
  end
end
