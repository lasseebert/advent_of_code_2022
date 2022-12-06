defmodule Advent.Day06Test do
  use Advent.Test.Case

  alias Advent.Day06

  @example_inputs [
    "mjqjpqmgbljsphdztnvjfqwrcgsmlb",
    "bvwbjplbgvbhsrlpgdmjqwftvncz",
    "nppdvjthqldpwncqszvftbrmjlhg",
    "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg",
    "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"
  ]

  @expected_part_1 [7, 5, 6, 10, 11]
  @expected_part_2 [19, 23, 23, 29, 26]

  @puzzle_input File.read!("puzzle_inputs/day_06.txt")

  describe "part 1" do
    @example_inputs
    |> Enum.zip(@expected_part_1)
    |> Enum.with_index()
    |> Enum.map(fn {{input, expected}, index} ->
      test "example #{index + 1}" do
        assert Day06.part_1(unquote(input)) == unquote(expected)
      end
    end)

    @tag :puzzle_input
    test "puzzle input" do
      assert Day06.part_1(@puzzle_input) == 1647
    end
  end

  describe "part 2" do
    @example_inputs
    |> Enum.zip(@expected_part_2)
    |> Enum.with_index()
    |> Enum.map(fn {{input, expected}, index} ->
      test "example #{index + 1}" do
        assert Day06.part_2(unquote(input)) == unquote(expected)
      end
    end)

    @tag :puzzle_input
    test "puzzle input" do
      assert Day06.part_2(@puzzle_input) == 2447
    end
  end
end
