defmodule Advent.Day08 do
  @moduledoc """
  Day 08
  """

  @doc """
  Part 1

  Consider your map; how many trees are visible from outside the grid?
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    heights = parse(input)
    max_x = heights |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.max()
    max_y = heights |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.max()

    [
      {0..max_x, 0..max_y, true},
      {0..max_x, max_y..0, true},
      {0..max_y, 0..max_x, false},
      {0..max_y, max_x..0, false}
    ]
    |> Enum.reduce(MapSet.new(), fn {range_1, range_2, x_first}, visible ->
      set_visible_single_dir(range_1, range_2, x_first, visible, heights)
    end)
    |> Enum.count()
  end

  defp set_visible_single_dir(range_1, range_2, x_first, visible, heights) do
    Enum.reduce(range_1, visible, fn x, visible ->
      set_visible_single_row(x, range_2, x_first, visible, heights)
    end)
  end

  defp set_visible_single_row(x, range_2, x_first, visible, heights) do
    tallest = -1

    {visible, _tallest} =
      Enum.reduce(range_2, {visible, tallest}, fn y, {visible, tallest} ->
        coord = if x_first, do: {x, y}, else: {y, x}
        tree = Map.fetch!(heights, coord)

        if tree > tallest do
          {MapSet.put(visible, coord), tree}
        else
          {visible, tallest}
        end
      end)

    visible
  end

  @doc """
  Part 2

  Consider each tree on your map. What is the highest scenic score possible for any tree?
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    heights = parse(input)

    max_x = heights |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.max()
    max_y = heights |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.max()

    heights
    |> Map.keys()
    |> Enum.map(&scenic_score(&1, max_x, max_y, heights))
    |> Enum.max()
  end

  defp scenic_score({0, _}, _, _, _), do: 0
  defp scenic_score({_, 0}, _, _, _), do: 0
  defp scenic_score({max_x, _}, max_x, _, _), do: 0
  defp scenic_score({_, max_y}, _, max_y, _), do: 0

  defp scenic_score(coord, max_x, max_y, heights) do
    tree = Map.fetch!(heights, coord)

    [
      {-1, 0},
      {1, 0},
      {0, -1},
      {0, 1}
    ]
    |> Enum.map(fn dir ->
      coord
      |> add(dir)
      |> Stream.iterate(&add(&1, dir))
      |> Enum.reduce_while(0, fn new_coord, count ->
        reduce_single_point(new_coord, count, max_x, max_y, tree, heights)
      end)
    end)
    |> Enum.reduce(&(&1 * &2))
  end

  defp reduce_single_point(new_coord, count, max_x, max_y, tree, heights) do
    cond do
      # We reached the edge
      !inside_forest?(new_coord, max_x, max_y) -> {:halt, count}
      # We reached a taller tree, so we stop, but this tree should also count
      Map.fetch!(heights, new_coord) >= tree -> {:halt, count + 1}
      # Continue to next tree
      true -> {:cont, count + 1}
    end
  end

  defp add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}
  defp inside_forest?({x, y}, max_x, max_y), do: 0 <= x and x <= max_x and 0 <= y and y <= max_y

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, map ->
      line
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.reduce(map, fn {height, x}, map -> Map.put(map, {x, y}, height) end)
    end)
  end
end
