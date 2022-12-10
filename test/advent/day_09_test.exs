defmodule Advent.Day09Test do
  use Advent.Test.Case

  alias Advent.Day09

  @example_input_1 """
  R 4
  U 4
  L 3
  D 1
  R 4
  D 1
  L 5
  R 2
  """

  @example_input_2 """
  R 5
  U 8
  L 8
  D 3
  R 17
  D 10
  L 25
  U 20
  """

  @puzzle_input File.read!("puzzle_inputs/day_09.txt")

  describe "part 1" do
    test "example" do
      assert Day09.part_1(@example_input_1) == 13
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day09.part_1(@puzzle_input) == 6337
    end
  end

  describe "part 2" do
    test "example 1" do
      assert Day09.part_2(@example_input_1) == 1
    end

    test "example 2" do
      assert Day09.part_2(@example_input_2) == 36
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day09.part_2(@puzzle_input) == 2455
      # 2084 is too low
    end
  end
end
