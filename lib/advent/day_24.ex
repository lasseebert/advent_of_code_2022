defmodule Advent.Day24 do
  @moduledoc """
  Day 24
  """

  @doc """
  Part 1

  What is the fewest number of minutes required to avoid the blizzards and reach the goal?
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> init_state()
    |> min_distance()
  end

  @doc """
  Part 2

  What is the fewest number of minutes required to reach the goal, go back to the start, then reach the goal again?
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> init_state()
    |> min_distance_back_and_forth()
  end

  defp min_distance(state, mode \\ :norm) do
    do_min_distance(state, 0, {%{}, :infinity}, mode)
    |> elem(0)
  end

  defp min_distance_back_and_forth(first_state) do
    first = min_distance(first_state)

    second_state = %{
      first_state
      | pos: first_state.dest,
        dest: first_state.pos,
        cycle: rem(first, first_state.cycle_length)
    }

    second = min_distance(second_state, :rev)

    third_state = %{first_state | cycle: rem(first + second, first_state.cycle_length)}
    third = min_distance(third_state)

    [first, second, third] |> Enum.sum()
  end

  defp do_min_distance(state, dist, {mins, best_so_far}, mode) do
    cond do
      state.pos == state.dest ->
        best_so_far = [best_so_far, dist] |> Enum.reject(&(&1 == :infinity)) |> Enum.min()
        {dist, {mins, best_so_far}}

      best_so_far != :infinity and dist + manhattan(state.pos, state.dest) >= best_so_far ->
        {nil, {mins, best_so_far}}

      better_cache?(state, dist, mins) ->
        {nil, {mins, best_so_far}}

      true ->
        mins = Map.update(mins, {state.cycle, state.pos}, dist, &Enum.min([&1, dist]))
        new_cycle = rem(state.cycle + 1, state.cycle_length)
        map = Map.fetch!(state.maps, new_cycle)

        {next_results, {mins, best_so_far}} =
          [{1, 0}, {0, 1}, {0, 0}, {-1, 0}, {0, -1}]
          |> then(fn dirs ->
            case mode do
              :norm -> dirs
              :rev -> Enum.reverse(dirs)
            end
          end)
          |> Enum.map_reduce({mins, best_so_far}, fn dir, {mins, best_so_far} ->
            new_pos = add(state.pos, dir)

            case Map.fetch(map, new_pos) do
              {:ok, :wall} ->
                {nil, {mins, best_so_far}}

              {:ok, []} ->
                new_state = %{state | pos: new_pos, cycle: new_cycle}
                do_min_distance(new_state, dist + 1, {mins, best_so_far}, mode)

              {:ok, _} ->
                {nil, {mins, best_so_far}}

              :error ->
                {nil, {mins, best_so_far}}
            end
          end)

        next_results
        |> Enum.reject(&is_nil/1)
        |> case do
          [] ->
            {nil, {mins, best_so_far}}

          results ->
            {Enum.min(results), {mins, best_so_far}}
        end
    end
  end

  defp better_cache?(state, dist, mins) do
    case Map.fetch(mins, {state.cycle, state.pos}) do
      :error ->
        false

      {:ok, cache} ->
        dist >= cache
    end
  end

  defp add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}
  defp manhattan({x1, y1}, {x2, y2}), do: abs(x1 - x2) + abs(y1 - y2)
  defp lcd(a, b), do: div(a * b, Integer.gcd(a, b))

  defp init_state(map) do
    max_x = map |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.max()
    max_y = map |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.max()

    cycle_length = lcd(max_x - 1, max_y - 1)

    maps =
      map
      |> Stream.iterate(fn map ->
        map
        |> Enum.filter(fn {_, item} -> is_list(item) end)
        |> Enum.reduce(map, fn {pos, blizzards}, map ->
          Enum.reduce(blizzards, map, fn blizzard, map ->
            dest =
              pos
              |> add(blizzard)
              |> case do
                {0, y} -> {max_x - 1, y}
                {x, y} when x == max_x -> {1, y}
                {x, 0} -> {x, max_y - 1}
                {x, y} when y == max_y -> {x, 1}
                {x, y} -> {x, y}
              end

            map
            |> Map.update!(dest, &[blizzard | &1])
            |> Map.update!(pos, &List.delete(&1, blizzard))
          end)
        end)
      end)
      |> Stream.with_index()
      |> Stream.take(cycle_length)
      |> Enum.into(%{}, fn {map, index} -> {index, map} end)

    source = map |> Enum.find(fn {{_x, y}, item} -> y == 0 and item == [] end) |> elem(0)
    dest = map |> Enum.find(fn {{_x, y}, item} -> y == max_y and item == [] end) |> elem(0)

    %{
      maps: maps,
      pos: source,
      dest: dest,
      cycle: 0,
      cycle_length: cycle_length
    }
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, map ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(map, fn {char, x}, map ->
        case char do
          "#" -> Map.put(map, {x, y}, :wall)
          "." -> Map.put(map, {x, y}, [])
          "<" -> Map.put(map, {x, y}, [{-1, 0}])
          ">" -> Map.put(map, {x, y}, [{1, 0}])
          "^" -> Map.put(map, {x, y}, [{0, -1}])
          "v" -> Map.put(map, {x, y}, [{0, 1}])
        end
      end)
    end)
  end
end
