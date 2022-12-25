defmodule Advent.Day25Test do
  use Advent.Test.Case

  alias Advent.Day25

  @example_input """
  1=-0-2
  12111
  2=0=
  21
  2=01
  111
  20012
  112
  1=-1=
  1-12
  12
  1=
  122
  """

  @puzzle_input File.read!("puzzle_inputs/day_25.txt")

  describe "part 1" do
    test "example" do
      assert Day25.part_1(@example_input) == "2=-1=0"
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day25.part_1(@puzzle_input) == :foo
    end
  end
end
