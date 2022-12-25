defmodule Advent.Day23 do
  @moduledoc """
  Day 23
  """

  @doc """
  Part 1

  Simulate the Elves' process and find the smallest rectangle that contains the Elves
  after 10 rounds. How many empty ground tiles does that rectangle contain?
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> iterate()
    |> Enum.at(10)
    |> free_space()
  end

  @doc """
  Part 2

  Figure out where the Elves need to go. What is the number of the first round where no Elf moves?
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> iterate()
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.with_index()
    |> Enum.find(fn {[e1, e2], _index} -> e1 == e2 end)
    |> then(fn {_, index} -> index + 1 end)
  end

  defp iterate(elves) do
    dirs = [
      [{-1, -1}, {0, -1}, {1, -1}],
      [{-1, 1}, {0, 1}, {1, 1}],
      [{-1, -1}, {-1, 0}, {-1, 1}],
      [{1, -1}, {1, 0}, {1, 1}]
    ]

    {elves, dirs}
    |> Stream.iterate(fn {elves, dirs} ->
      elves
      |> Enum.flat_map(&proposed_move(&1, dirs, elves))
      |> Enum.group_by(fn {_src, dest} -> dest end)
      |> Enum.map(&elem(&1, 1))
      |> Enum.filter(&(length(&1) == 1))
      |> Enum.flat_map(& &1)
      |> Enum.reduce(elves, fn {src, dest}, elves ->
        elves
        |> MapSet.delete(src)
        |> MapSet.put(dest)
      end)
      |> then(fn elves ->
        [first | rest] = dirs
        {elves, rest ++ [first]}
      end)
    end)
    |> Stream.map(fn {elves, _dirs} -> elves end)
  end

  defp proposed_move(elf, dirs, elves) do
    if alone?(elf, elves) do
      []
    else
      dirs
      |> Enum.find(fn deltas ->
        Enum.all?(deltas, fn delta -> add(delta, elf) not in elves end)
      end)
      |> case do
        nil -> []
        [_, dir, _] -> [{elf, add(elf, dir)}]
      end
    end
  end

  defp alone?(elf, elves) do
    for dx <- -1..1,
        dy <- -1..1,
        dx != 0 or dy != 0 do
      {dx, dy}
    end
    |> Enum.all?(&(add(&1, elf) not in elves))
  end

  defp add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  defp free_space(elves) do
    {min_x, max_x} = elves |> Enum.map(&elem(&1, 0)) |> Enum.min_max()
    {min_y, max_y} = elves |> Enum.map(&elem(&1, 1)) |> Enum.min_max()

    box_size = (max_x - min_x + 1) * (max_y - min_y + 1)
    num_elves = Enum.count(elves)
    box_size - num_elves
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(MapSet.new(), fn {line, y}, elves ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.filter(fn {char, _x} -> char == "#" end)
      |> Enum.map(fn {_char, x} -> x end)
      |> Enum.reduce(elves, fn x, elves -> MapSet.put(elves, {x, y}) end)
    end)
  end
end
