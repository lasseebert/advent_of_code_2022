defmodule Advent.Day21Test do
  use Advent.Test.Case

  alias Advent.Day21

  @example_input """
  root: pppw + sjmn
  dbpl: 5
  cczh: sllz + lgvd
  zczc: 2
  ptdq: humn - dvpt
  dvpt: 3
  lfqf: 4
  humn: 5
  ljgn: 2
  sjmn: drzm * dbpl
  sllz: 4
  pppw: cczh / lfqf
  lgvd: ljgn * ptdq
  drzm: hmdt - zczc
  hmdt: 32
  """

  @puzzle_input File.read!("puzzle_inputs/day_21.txt")

  describe "part 1" do
    test "example" do
      assert Day21.part_1(@example_input) == 152
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day21.part_1(@puzzle_input) == 331_319_379_445_180
    end
  end

  describe "part 2" do
    test "example" do
      assert Day21.part_2(@example_input) == 301
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day21.part_2(@puzzle_input) == 3_715_799_488_132
    end
  end
end
