defmodule Advent.Day15Test do
  use Advent.Test.Case

  alias Advent.Day15

  @example_input """
  Sensor at x=2, y=18: closest beacon is at x=-2, y=15
  Sensor at x=9, y=16: closest beacon is at x=10, y=16
  Sensor at x=13, y=2: closest beacon is at x=15, y=3
  Sensor at x=12, y=14: closest beacon is at x=10, y=16
  Sensor at x=10, y=20: closest beacon is at x=10, y=16
  Sensor at x=14, y=17: closest beacon is at x=10, y=16
  Sensor at x=8, y=7: closest beacon is at x=2, y=10
  Sensor at x=2, y=0: closest beacon is at x=2, y=10
  Sensor at x=0, y=11: closest beacon is at x=2, y=10
  Sensor at x=20, y=14: closest beacon is at x=25, y=17
  Sensor at x=17, y=20: closest beacon is at x=21, y=22
  Sensor at x=16, y=7: closest beacon is at x=15, y=3
  Sensor at x=14, y=3: closest beacon is at x=15, y=3
  Sensor at x=20, y=1: closest beacon is at x=15, y=3
  """

  @puzzle_input File.read!("puzzle_inputs/day_15.txt")

  describe "part 1" do
    test "example" do
      assert Day15.part_1(@example_input, 10) == 26
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day15.part_1(@puzzle_input, 2_000_000) == 5_367_037
    end
  end

  describe "part 2" do
    test "example" do
      assert Day15.part_2(@example_input, 20) == 56_000_011
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day15.part_2(@puzzle_input, 4_000_000) == 11_914_583_249_288
    end
  end
end
