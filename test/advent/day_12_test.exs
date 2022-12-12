defmodule Advent.Day12Test do
  use Advent.Test.Case

  alias Advent.Day12

  @example_input """
  Sabqponm
  abcryxxl
  accszExk
  acctuvwj
  abdefghi
  """

  @puzzle_input File.read!("puzzle_inputs/day_12.txt")

  describe "part 1" do
    test "example" do
      assert Day12.part_1(@example_input) == 31
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day12.part_1(@puzzle_input) == 449
    end
  end

  describe "part 2" do
    test "example" do
      assert Day12.part_2(@example_input) == 29
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day12.part_2(@puzzle_input) == 443
    end
  end
end
