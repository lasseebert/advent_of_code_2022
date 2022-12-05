defmodule Advent.Day05Test do
  use Advent.Test.Case

  alias Advent.Day05

  @example_input """
      [D]    
  [N] [C]    
  [Z] [M] [P]
   1   2   3 

  move 1 from 2 to 1
  move 3 from 1 to 3
  move 2 from 2 to 1
  move 1 from 1 to 2
  """

  @puzzle_input File.read!("puzzle_inputs/day_05.txt")

  describe "part 1" do
    test "example" do
      assert Day05.part_1(@example_input) == "CMZ"
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day05.part_1(@puzzle_input) == "TGWSMRBPN"
    end
  end

  describe "part 2" do
    test "example" do
      assert Day05.part_2(@example_input) == "MCD"
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day05.part_2(@puzzle_input) == "TZLTLWRNF"
    end
  end
end
