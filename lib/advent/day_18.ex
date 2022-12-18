defmodule Advent.Day18 do
  @moduledoc """
  Day 18
  """

  @doc """
  Part 1

  What is the surface area of your scanned lava droplet?
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> surface_area_sum()
  end

  defp surface_area_sum(cubes) do
    cubes
    |> Enum.map(&surface_area(&1, cubes))
    |> Enum.sum()
  end

  defp surface_area(cube, cubes) do
    directions()
    |> Enum.filter(&(add(&1, cube) not in cubes))
    |> length()
  end

  @doc """
  Part 2

  What is the exterior surface area of your scanned lava droplet?
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> exterior_surface_area_sum()
  end

  defp exterior_surface_area_sum(cubes) do
    static = %{
      cubes: cubes,
      box: bounding_box(cubes)
    }

    caches = %{
      ext: MapSet.new(),
      int: MapSet.new()
    }

    cubes
    |> Enum.flat_map_reduce(caches, &exterior_surface_area(&1, &2, static))
    |> elem(0)
    |> Enum.sum()
  end

  defp exterior_surface_area(cube, caches, static) do
    Enum.map_reduce(directions(), caches, fn dir, caches ->
      point = add(cube, dir)
      explore(MapSet.new(), [point], caches, static)
    end)
  end

  defp explore(visited, [], caches, _static), do: {0, %{caches | int: MapSet.union(caches.int, visited)}}

  defp explore(visited, [point | worklist], caches, static) do
    cond do
      point in static.cubes or point in visited ->
        explore(visited, worklist, caches, static)

      point in caches.int ->
        {0, %{caches | int: MapSet.union(caches.int, visited)}}

      point in caches.ext or on_or_outside_box(point, static.box) ->
        {1, %{caches | ext: MapSet.union(caches.ext, visited)}}

      true ->
        visited = MapSet.put(visited, point)
        neighbours = directions() |> Enum.map(&add(&1, point))
        explore(visited, neighbours ++ worklist, caches, static)
    end
  end

  defp bounding_box(cubes) do
    0..2
    |> Enum.map(fn index ->
      cubes |> Enum.map(&elem(&1, index)) |> Enum.min_max() |> Tuple.to_list()
    end)
    |> Enum.zip()
    |> List.to_tuple()
  end

  defp on_or_outside_box({x, y, z}, {{bx1, by1, bz1}, {bx2, by2, bz2}}) do
    x <= bx1 or x >= bx2 or y <= by1 or y >= by2 or z <= bz1 or z >= bz2
  end

  defp directions do
    [
      {-1, 0, 0},
      {1, 0, 0},
      {0, -1, 0},
      {0, 1, 0},
      {0, 0, -1},
      {0, 0, 1}
    ]
  end

  defp add({x1, y1, z1}, {x2, y2, z2}), do: {x1 + x2, y1 + y2, z1 + z2}

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> MapSet.new()
  end
end
