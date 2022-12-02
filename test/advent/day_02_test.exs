defmodule Advent.Day02Test do
  use Advent.Test.Case

  alias Advent.Day02

  @example_input """
  A Y
  B X
  C Z
  """

  @puzzle_input File.read!("puzzle_inputs/day_02.txt")

  describe "part 1" do
    test "example" do
      assert Day02.part_1(@example_input) == 15
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day02.part_1(@puzzle_input) == 10_816
    end
  end

  describe "part 2" do
    test "example" do
      assert Day02.part_2(@example_input) == 12
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day02.part_2(@puzzle_input) == 11_657
    end
  end
end
