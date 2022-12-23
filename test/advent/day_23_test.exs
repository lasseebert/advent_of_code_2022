defmodule Advent.Day23Test do
  use Advent.Test.Case

  alias Advent.Day23

  @example_input """
  ....#..
  ..###.#
  #...#.#
  .#...##
  #.###..
  ##.#.##
  .#..#..
  """

  @puzzle_input File.read!("puzzle_inputs/day_23.txt")

  describe "part 1" do
    test "example" do
      assert Day23.part_1(@example_input) == 110
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day23.part_1(@puzzle_input) == 3987
    end
  end

  describe "part 2" do
    test "example" do
      assert Day23.part_2(@example_input) == 20
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day23.part_2(@puzzle_input) == 938
    end
  end
end
