defmodule Advent.Day13Test do
  use Advent.Test.Case

  alias Advent.Day13

  @example_input """
  [1,1,3,1,1]
  [1,1,5,1,1]

  [[1],[2,3,4]]
  [[1],4]

  [9]
  [[8,7,6]]

  [[4,4],4,4]
  [[4,4],4,4,4]

  [7,7,7,7]
  [7,7,7]

  []
  [3]

  [[[]]]
  [[]]

  [1,[2,[3,[4,[5,6,7]]]],8,9]
  [1,[2,[3,[4,[5,6,0]]]],8,9]
  """

  @puzzle_input File.read!("puzzle_inputs/day_13.txt")

  describe "part 1" do
    test "example" do
      assert Day13.part_1(@example_input) == 13
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day13.part_1(@puzzle_input) == 5675
    end
  end

  describe "part 2" do
    test "example" do
      assert Day13.part_2(@example_input) == 140
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day13.part_2(@puzzle_input) == 20_383
    end
  end
end
