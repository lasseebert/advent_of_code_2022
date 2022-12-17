defmodule Advent.Day16Test do
  use Advent.Test.Case

  alias Advent.Day16

  @example_input """
  Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
  Valve BB has flow rate=13; tunnels lead to valves CC, AA
  Valve CC has flow rate=2; tunnels lead to valves DD, BB
  Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
  Valve EE has flow rate=3; tunnels lead to valves FF, DD
  Valve FF has flow rate=0; tunnels lead to valves EE, GG
  Valve GG has flow rate=0; tunnels lead to valves FF, HH
  Valve HH has flow rate=22; tunnel leads to valve GG
  Valve II has flow rate=0; tunnels lead to valves AA, JJ
  Valve JJ has flow rate=21; tunnel leads to valve II
  """

  @puzzle_input File.read!("puzzle_inputs/day_16.txt")

  describe "part 1" do
    test "example" do
      assert Day16.part_1(@example_input) == 1651
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day16.part_1(@puzzle_input) == 1559
    end
  end

  describe "part 2" do
    test "example" do
      assert Day16.part_2(@example_input) == 1707
    end

    @tag timeout: :infinity
    @tag :puzzle_input
    test "puzzle input" do
      assert Day16.part_2(@puzzle_input) == 2191
    end
  end
end
