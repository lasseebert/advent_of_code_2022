defmodule Advent.Day14 do
  @moduledoc """
  Day 14
  """

  @doc """
  Part 1

  Using your scan, simulate the falling sand. How many units of sand come to rest before sand starts flowing into the
  abyss below?
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    rocks_map = parse(input)
    lowest_rock = rocks_map |> Enum.map(fn {_x, y} -> y end) |> Enum.max()

    %{
      rock?: fn pos -> pos in rocks_map end,
      lowest_rock: lowest_rock,
      source: {500, 0}
    }
    |> solve()
  end

  @doc """
  Part 2

  Using your scan, simulate the falling sand until the source of the sand becomes blocked. How many units of sand come
  to rest?
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    rocks_map = parse(input)
    lowest_rock = rocks_map |> Enum.map(fn {_x, y} -> y end) |> Enum.max()

    %{
      rock?: fn {_x, y} = pos -> pos in rocks_map or y == lowest_rock + 2 end,
      lowest_rock: lowest_rock + 2,
      source: {500, 0}
    }
    |> solve()
  end

  defp solve(cave) do
    MapSet.new()
    |> flow([cave.source], cave)
    |> Enum.count()
  end

  # Source is blocked
  defp flow(still_sand, [], _cave), do: still_sand

  # Abyss is reached
  defp flow(still_sand, [{_x, y} | _], %{lowest_rock: y}), do: still_sand

  # Sand is flowing
  defp flow(still_sand, [lowest | flow_sand], cave) do
    [{0, 1}, {-1, 1}, {1, 1}]
    |> Enum.map(&add(lowest, &1))
    |> Enum.find(fn new_pos -> new_pos not in still_sand and not cave.rock?.(new_pos) end)
    |> case do
      nil -> still_sand |> MapSet.put(lowest) |> flow(flow_sand, cave)
      new_pos -> flow(still_sand, [new_pos, lowest | flow_sand], cave)
    end
  end

  defp add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  # Returns a MapSet of all single rocks
  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.reduce(MapSet.new(), fn line, rocks ->
      line
      |> String.split(" -> ")
      |> Enum.map(fn coord ->
        coord
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(&(&1 |> Enum.sort() |> List.to_tuple()))
      |> Enum.reduce(rocks, fn {{x1, y1}, {x2, y2}}, rocks ->
        for x <- x1..x2,
            y <- y1..y2 do
          {x, y}
        end
        |> Enum.reduce(rocks, fn coord, rocks -> MapSet.put(rocks, coord) end)
      end)
    end)
  end
end
