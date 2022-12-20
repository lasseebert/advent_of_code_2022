defmodule Advent.Day20Test do
  use Advent.Test.Case

  alias Advent.Day20

  @example_input """
  1
  2
  -3
  3
  -2
  0
  4
  """

  @puzzle_input File.read!("puzzle_inputs/day_20.txt")

  describe "part 1" do
    test "example" do
      assert Day20.part_1(@example_input) == 3
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day20.part_1(@puzzle_input) == 13_883
    end
  end

  describe "part 2" do
    test "example" do
      assert Day20.part_2(@example_input) == 1_623_178_306
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day20.part_2(@puzzle_input) == 19_185_967_576_920
    end
  end
end
