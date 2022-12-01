defmodule Advent.Day01Test do
  use Advent.Test.Case

  alias Advent.Day01

  @example_input """
  1000
  2000
  3000

  4000

  5000
  6000

  7000
  8000
  9000

  10000
  """

  @puzzle_input File.read!("puzzle_inputs/day_01.txt")

  describe "part 1" do
    test "example" do
      assert Day01.part_1(@example_input) == 24_000
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day01.part_1(@puzzle_input) == 72_602
    end
  end

  describe "part 2" do
    test "example" do
      assert Day01.part_2(@example_input) == 45_000
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day01.part_2(@puzzle_input) == 207_410
    end
  end
end
