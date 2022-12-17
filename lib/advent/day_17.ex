defmodule Advent.Day17 do
  @moduledoc """
  Day 17
  """

  @doc """
  Part 1

  How many units tall will the tower of rocks be after 2022 rocks have stopped falling?
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> init_state()
    |> iterate()
    |> Enum.find(&(&1.num_rocks == 2022))
    |> Map.fetch!(:top_rock)
  end

  @doc """
  Part 2

  How tall will the tower be after 1000000000000 rocks have stopped?

  Runs in ~0.3 seconds
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    jets = parse(input)

    jets_length = length(jets)
    rocks_length = 5

    # Not sure why this is :)
    cycle_length =
      if rem(jets_length, rocks_length) == 0 do
        jets_length * rocks_length
      else
        jets_length
      end

    [state_1, state_2] =
      jets
      |> init_state()
      |> iterate()
      |> Stream.chunk_by(& &1.time)
      |> Stream.map(&hd/1)
      |> Stream.take_every(cycle_length)
      |> Stream.drop(1)
      |> Enum.take(2)

    # This is the result of the first two cycles
    # First diff is different from the rest, so that is handled specially
    # All the remaining cycle diffs are the same as the second cycle diff, so we can just multiply
    num_1 = state_1.num_rocks
    num_2 = state_2.num_rocks - state_1.num_rocks

    top_1 = state_1.top_rock
    top_2 = state_2.top_rock - state_1.top_rock

    num_rocks = 1_000_000_000_000

    # First cycle
    height = top_1
    rocks_left = num_rocks - num_1

    # Use second cycle to calculate the rest
    height = height + div(rocks_left, num_2) * top_2
    rocks_left = rem(rocks_left, num_2)

    # Now we only need the last rocks that was not accounted for in the cycle
    last_height =
      state_2
      |> iterate()
      |> Stream.chunk_by(& &1.num_rocks)
      |> Stream.map(&hd/1)
      |> Stream.map(& &1.top_rock)
      |> Stream.take_every(rocks_left)
      |> Enum.take(2)
      |> then(fn [a, b] -> b - a end)

    height + last_height
  end

  defp init_state(jets) do
    num_jets = length(jets)
    jets = {num_jets, jets}

    map = 0..6 |> Enum.map(&{&1, 0}) |> MapSet.new()

    %{
      map: map,
      num_rocks: 0,
      time: 0,
      active_rock: nil,
      top_rock: 0,
      jets: jets
    }
  end

  defp iterate(state) do
    Stream.iterate(state, fn state ->
      if state.active_rock == nil do
        rock =
          state.num_rocks
          |> create_rock()
          |> add({2, state.top_rock + 4})

        %{state | active_rock: rock}
      else
        state.active_rock
        |> move_sideways(state.jets, state.time, state.map)
        |> move_down(state.map)
        |> case do
          {:collision, rock} ->
            %{
              state
              | map: Enum.reduce(rock, state.map, &MapSet.put(&2, &1)),
                num_rocks: state.num_rocks + 1,
                time: state.time + 1,
                active_rock: nil,
                top_rock: [state.top_rock | Enum.map(rock, &elem(&1, 1))] |> Enum.max()
            }

          {:ok, rock} ->
            %{
              state
              | time: state.time + 1,
                active_rock: rock
            }
        end
      end
    end)
  end

  defp move_down(rock, map) do
    moved_rock = add(rock, {0, -1})

    if collision?(moved_rock, map) do
      {:collision, rock}
    else
      {:ok, moved_rock}
    end
  end

  defp move_sideways(rock, jets, time, map) do
    direction = jet_direction(jets, time)
    moved_rock = add(rock, direction)

    if collision?(moved_rock, map) do
      rock
    else
      moved_rock
    end
  end

  defp jet_direction({count, jets}, n) do
    n = rem(n, count)
    Enum.at(jets, n)
  end

  defp collision?(rock, map) do
    Enum.any?(rock, fn {x, _y} = coord -> coord in map or x < 0 or x > 6 end)
  end

  defp create_rock(n) when rem(n, 5) == 0, do: [{0, 0}, {1, 0}, {2, 0}, {3, 0}]
  defp create_rock(n) when rem(n, 5) == 1, do: [{1, 0}, {0, 1}, {1, 1}, {2, 1}, {1, 2}]
  defp create_rock(n) when rem(n, 5) == 2, do: [{0, 0}, {1, 0}, {2, 0}, {2, 1}, {2, 2}]
  defp create_rock(n) when rem(n, 5) == 3, do: [{0, 0}, {0, 1}, {0, 2}, {0, 3}]
  defp create_rock(n) when rem(n, 5) == 4, do: [{0, 0}, {1, 0}, {0, 1}, {1, 1}]

  defp add(list, {_, _} = point) when is_list(list), do: Enum.map(list, &add(&1, point))
  defp add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  defp parse(input) do
    input
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(fn
      ">" -> {1, 0}
      "<" -> {-1, 0}
    end)
  end
end
