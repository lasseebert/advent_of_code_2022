defmodule Advent.Day09 do
  @moduledoc """
  Day 09
  """

  @doc """
  Part 1

  Simulate your complete hypothetical series of motions. How many positions does the tail of the rope visit at least
  once?
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    solve(input, 2)
  end

  @doc """
  Part 2

  Simulate your complete series of motions on a larger rope with ten knots. How many positions does the tail of the
  rope visit at least once?
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    solve(input, 10)
  end

  defp solve(input, rope_length) do
    moves = parse(input)

    start_position = List.duplicate({0, 0}, rope_length)

    {positions, _acc} =
      Enum.flat_map_reduce(moves, start_position, fn {dir, count}, pos ->
        1..count
        |> Enum.map_reduce(pos, fn _, pos ->
          new_pos = move(dir, pos)
          {new_pos, new_pos}
        end)
      end)

    positions = [start_position | positions]

    positions
    |> Enum.map(&List.last/1)
    |> Enum.uniq()
    |> length()
  end

  defp move(dir, pos), do: pos |> move_head(dir) |> move_tail

  defp move_head([head | tail], :up), do: [add(head, {0, 1}) | tail]
  defp move_head([head | tail], :down), do: [add(head, {0, -1}) | tail]
  defp move_head([head | tail], :left), do: [add(head, {-1, 0}) | tail]
  defp move_head([head | tail], :right), do: [add(head, {1, 0}) | tail]

  defp move_tail([head]), do: [head]

  defp move_tail([head | tail]) do
    [first | rest] = tail

    first =
      case sub(head, first) do
        {x, y} when -1 <= x and x <= 1 and -1 <= y and y <= 1 -> first
        {x, -2} when -1 <= x and x <= 1 -> sub(head, {0, -1})
        {-2, y} when -1 <= y and y <= 1 -> sub(head, {-1, 0})
        {x, 2} when -1 <= x and x <= 1 -> sub(head, {0, 1})
        {2, y} when -1 <= y and y <= 1 -> sub(head, {1, 0})
        {-2, -2} -> sub(head, {-1, -1})
        {-2, 2} -> sub(head, {-1, 1})
        {2, -2} -> sub(head, {1, -1})
        {2, 2} -> sub(head, {1, 1})
      end

    [head | move_tail([first | rest])]
  end

  defp add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}
  defp sub({x1, y1}, {x2, y2}), do: {x1 - x2, y1 - y2}

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [dir, count] = String.split(line, " ")

      dir =
        case dir do
          "R" -> :right
          "L" -> :left
          "U" -> :up
          "D" -> :down
        end

      count = String.to_integer(count)

      {dir, count}
    end)
  end
end
