defmodule Advent.Day08Test do
  use Advent.Test.Case

  alias Advent.Day08

  @example_input """
  30373
  25512
  65332
  33549
  35390
  """

  @puzzle_input File.read!("puzzle_inputs/day_08.txt")

  describe "part 1" do
    test "example" do
      assert Day08.part_1(@example_input) == 21
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day08.part_1(@puzzle_input) == 1538
    end
  end

  describe "part 2" do
    test "example" do
      assert Day08.part_2(@example_input) == 8
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day08.part_2(@puzzle_input) == 496_125
    end
  end
end
