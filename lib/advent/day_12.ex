defmodule Advent.Day12 do
  @moduledoc """
  Day 12
  """

  @doc """
  Part 1

  What is the fewest steps required to move from your current position to the location that should get the best signal?
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    {map, pos, goal} = parse(input)

    distances = %{pos => 0}
    worklist = MapSet.new([pos])

    find_goal_part_1(map, distances, worklist, goal)
  end

  defp find_goal_part_1(map, distances, worklist, goal) do
    case Map.fetch(distances, goal) do
      # We stop as soon as we see the goal, since that must be the shortest route
      {:ok, distance_to_goal} ->
        distance_to_goal

      :error ->
        {distances, new_worklist} =
          worklist
          |> Enum.reduce({distances, MapSet.new()}, fn pos, {distances, new_worklist} ->
            pos
            |> possible_neighbours(map)
            |> Enum.reject(&Map.has_key?(distances, &1))
            |> Enum.reduce({distances, new_worklist}, fn neighbour, {distances, new_worklist} ->
              distances = Map.put(distances, neighbour, Map.fetch!(distances, pos) + 1)
              new_worklist = MapSet.put(new_worklist, neighbour)
              {distances, new_worklist}
            end)
          end)

        find_goal_part_1(map, distances, new_worklist, goal)
    end
  end

  @doc """
  Part 2

  What is the fewest steps required to move starting from any square with elevation a to the location that should get
  the best signal?
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    {map, pos, goal} = parse(input)

    distances = %{pos => 0}
    worklist = MapSet.new([pos])

    find_goal_part_2(map, distances, worklist, goal)
  end

  defp find_goal_part_2(map, distances, worklist, goal) do
    # In part 2 we can only stop when we have no more coords to look at, since looking at an "a" coord might change
    # everything.
    if Enum.empty?(worklist) do
      Map.fetch!(distances, goal)
    else
      {distances, new_worklist} =
        worklist
        |> Enum.reduce({distances, MapSet.new()}, fn pos, {distances, new_worklist} ->
          pos
          |> possible_neighbours(map)
          |> Enum.reduce({distances, new_worklist}, fn neighbour, {distances, new_worklist} ->
            distance =
              case Map.fetch!(map, neighbour) do
                0 -> 0
                _ -> Map.fetch!(distances, pos) + 1
              end

            better =
              case Map.fetch(distances, neighbour) do
                {:ok, n} -> n > distance
                :error -> true
              end

            if better do
              distances = Map.put(distances, neighbour, distance)
              new_worklist = MapSet.put(new_worklist, neighbour)
              {distances, new_worklist}
            else
              {distances, new_worklist}
            end
          end)
        end)

      find_goal_part_2(map, distances, new_worklist, goal)
    end
  end

  defp possible_neighbours(pos, map) do
    [
      {-1, 0},
      {1, 0},
      {0, -1},
      {0, 1}
    ]
    |> Enum.map(&add(&1, pos))
    |> Enum.filter(fn neighbour ->
      case Map.fetch(map, neighbour) do
        {:ok, height} -> height <= Map.fetch!(map, pos) + 1
        :error -> false
      end
    end)
  end

  defp add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  defp parse(input) do
    result = %{
      pos: nil,
      goal: nil,
      map: %{}
    }

    result =
      input
      |> String.trim()
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(result, fn {line, y}, result ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reduce(result, fn {char, x}, result ->
          case char do
            "S" -> %{result | pos: {x, y}, map: Map.put(result.map, {x, y}, 0)}
            "E" -> %{result | goal: {x, y}, map: Map.put(result.map, {x, y}, 25)}
            char -> %{result | map: Map.put(result.map, {x, y}, :binary.first(char) - ?a)}
          end
        end)
      end)

    {result.map, result.pos, result.goal}
  end
end
