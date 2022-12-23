defmodule Advent.Day22Test do
  use Advent.Test.Case

  alias Advent.Day22

  @example_input """
          ...#
          .#..
          #...
          ....
  ...#.......#
  ........#...
  ..#....#....
  ..........#.
          ...#....
          .....#..
          .#......
          ......#.

  10R5L5R10L4R5L5
  """

  @puzzle_input File.read!("puzzle_inputs/day_22.txt")

  describe "part 1" do
    test "example" do
      assert Day22.part_1(@example_input) == 6032
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day22.part_1(@puzzle_input) == 26_558
    end
  end

  describe "part 2" do
    test "example" do
      assert Day22.part_2(@example_input) == 5031
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day22.part_2(@puzzle_input) == 110_400
    end
  end
end
