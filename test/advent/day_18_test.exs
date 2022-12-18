defmodule Advent.Day18Test do
  use Advent.Test.Case

  alias Advent.Day18

  @example_input """
  2,2,2
  1,2,2
  3,2,2
  2,1,2
  2,3,2
  2,2,1
  2,2,3
  2,2,4
  2,2,6
  1,2,5
  3,2,5
  2,1,5
  2,3,5
  """

  @puzzle_input File.read!("puzzle_inputs/day_18.txt")

  describe "part 1" do
    test "example" do
      assert Day18.part_1(@example_input) == 64
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day18.part_1(@puzzle_input) == 3526
    end
  end

  describe "part 2" do
    test "example" do
      assert Day18.part_2(@example_input) == 58
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day18.part_2(@puzzle_input) == 2090
    end
  end
end
