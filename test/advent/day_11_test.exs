defmodule Advent.Day11Test do
  use Advent.Test.Case

  alias Advent.Day11

  @example_input """
  Monkey 0:
    Starting items: 79, 98
    Operation: new = old * 19
    Test: divisible by 23
      If true: throw to monkey 2
      If false: throw to monkey 3

  Monkey 1:
    Starting items: 54, 65, 75, 74
    Operation: new = old + 6
    Test: divisible by 19
      If true: throw to monkey 2
      If false: throw to monkey 0

  Monkey 2:
    Starting items: 79, 60, 97
    Operation: new = old * old
    Test: divisible by 13
      If true: throw to monkey 1
      If false: throw to monkey 3

  Monkey 3:
    Starting items: 74
    Operation: new = old + 3
    Test: divisible by 17
      If true: throw to monkey 0
      If false: throw to monkey 1
  """

  @puzzle_input File.read!("puzzle_inputs/day_11.txt")

  describe "part 1" do
    test "example" do
      assert Day11.part_1(@example_input) == 10_605
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day11.part_1(@puzzle_input) == 50_830
    end
  end

  describe "part 2" do
    test "example" do
      assert Day11.part_2(@example_input) == 2_713_310_158
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day11.part_2(@puzzle_input) == 14_399_640_002
    end
  end
end
