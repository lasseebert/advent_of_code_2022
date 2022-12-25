defmodule Advent.Day24Test do
  use Advent.Test.Case

  alias Advent.Day24

  @example_input """
  #.######
  #>>.<^<#
  #.<..<<#
  #>v.><>#
  #<^v^^>#
  ######.#
  """

  @puzzle_input File.read!("puzzle_inputs/day_24.txt")

  describe "part 1" do
    test "example" do
      assert Day24.part_1(@example_input) == 18
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day24.part_1(@puzzle_input) == 225
    end
  end

  describe "part 2" do
    test "example" do
      assert Day24.part_2(@example_input) == 54
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day24.part_2(@puzzle_input) == 711
    end
  end
end
