defmodule Advent.Day03Test do
  use Advent.Test.Case

  alias Advent.Day03

  @example_input """
  vJrwpWtwJgWrhcsFMMfFFhFp
  jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
  PmmdzqPrVvPwwTWBwg
  wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
  ttgJtRGJQctTZtZT
  CrZsJsPPZsGzwwsLwLmpwMDw
  """

  @puzzle_input File.read!("puzzle_inputs/day_03.txt")

  describe "part 1" do
    test "example" do
      assert Day03.part_1(@example_input) == 157
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day03.part_1(@puzzle_input) == 7917
    end
  end

  describe "part 2" do
    test "example" do
      assert Day03.part_2(@example_input) == 70
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day03.part_2(@puzzle_input) == 2585
    end
  end
end
