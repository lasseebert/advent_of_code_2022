defmodule Advent.Day16 do
  @moduledoc """
  Day 16
  """

  @doc """
  Part 1

  Work out the steps to release the most pressure in 30 minutes. What is the most pressure you can release?

  Runs in around 1.3 seconds on my machine
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    time = 30
    cave = parse(input)
    distances = calc_distances(cave)

    cave
    |> Enum.filter(fn {_valve, {rate, _routes}} -> rate > 0 end)
    |> Enum.map(&elem(&1, 0))
    |> permutations(time, distances)
    |> Enum.map(&calc_pressure(&1, time, cave, distances))
    |> Enum.max()
  end

  @doc """
  Part 2

  With you and an elephant working together for 26 minutes, what is the most pressure you could release?

  Current solution runs in 21 seconds on my machine
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    time = 26
    cave = parse(input)
    distances = calc_distances(cave)

    valves =
      cave
      |> Enum.filter(fn {_valve, {rate, _routes}} -> rate > 0 end)
      |> Enum.map(&elem(&1, 0))

    valves
    |> permutations(time, distances)
    |> Stream.reject(&length(&1) < div(length(valves), 2) - 1)
    |> Stream.map(fn human_permutation ->
      human_pressure = calc_pressure(human_permutation, time, cave, distances)

      elephant_pressure =
        (valves -- human_permutation)
        |> permutations(time, distances)
        |> Enum.map(&calc_pressure(&1, time, cave, distances))
        |> Enum.max()

      human_pressure + elephant_pressure
    end)
    |> Enum.max()
  end

  defp permutations(valves, time, distance) do
    valves
    |> find_permutations("AA", time, distance)
    # For some reasons that I do not yet understand, the results are not unique
    |> Enum.uniq()
  end

  defp find_permutations([], _pos, _, _), do: [[]]
  defp find_permutations(_valves, _pos, time, _distances) when time <= 0, do: [[]]

  defp find_permutations(valves, pos, time, distances) do
    perms =
      valves
      |> Enum.flat_map(fn first_valve ->
        time = time - Map.fetch!(distances, {pos, first_valve}) - 1

        if time < 0 do
          [[]]
        else
          (valves -- [first_valve])
          |> find_permutations(first_valve, time, distances)
          |> Enum.map(&[first_valve | &1])
        end
      end)

    [[] | perms]
  end

  defp calc_pressure(permutation, time, cave, distances) do
    %{
      time: time,
      pos: "AA",
      pressure: 0,
      route: permutation
    }
    |> Stream.iterate(fn
      %{route: []} = state ->
        %{state | time: 0}

      %{time: time} = state when time <= 0 ->
        state

      %{route: [target | route]} = state ->
        time = state.time - Map.fetch!(distances, {state.pos, target})

        if time <= 0 do
          %{state | time: time, pos: target}
        else
          time = time - 1
          rate = Map.fetch!(cave, target) |> elem(0)
          pressure = state.pressure + rate * time
          %{state | time: time, pos: target, pressure: pressure, route: route}
        end
    end)
    |> Stream.chunk_every(2, 1, :distances)
    |> Enum.find(fn [_, %{time: time}] -> time <= 0 end)
    |> hd()
    |> Map.fetch!(:pressure)
  end

  defp calc_distances(cave) do
    valves = Map.keys(cave)
    distances = Enum.into(valves, %{}, &{{&1, &1}, 0})

    Enum.reduce(valves, distances, &do_calc_distances(&1, [&1], cave, &2))
  end

  defp do_calc_distances(_start, [], _cave, distances), do: distances

  defp do_calc_distances(start, [valve | worklist], cave, distances) do
    current_distance = Map.fetch!(distances, {start, valve})
    next_distance = current_distance + 1

    {distances, worklist} =
      cave
      |> Map.fetch!(valve)
      |> elem(1)
      |> Enum.reduce({distances, worklist}, fn route, {distances, worklist} ->
        case Map.fetch(distances, {start, route}) do
          {:ok, dist} when dist < next_distance ->
            {
              distances,
              worklist
            }

          {:ok, dist} when dist >= next_distance ->
            {
              Map.put(distances, {start, route}, next_distance),
              [route | worklist]
            }

          :error ->
            {
              Map.put(distances, {start, route}, next_distance),
              [route | worklist]
            }
        end
      end)

    do_calc_distances(start, worklist, cave, distances)
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.into(%{}, &parse_line/1)
  end

  defp parse_line(line) do
    [valve, rate, routes] =
      ~r/^Valve ([A-Z]{2}) has flow rate=(\d+); tunnels? leads? to valves? ([A-Z]{2}(?:, [A-Z]{2})*)$/
      |> Regex.run(line, capture: :all_but_first)

    rate = String.to_integer(rate)
    routes = String.split(routes, ", ")
    {valve, {rate, routes}}
  end
end
