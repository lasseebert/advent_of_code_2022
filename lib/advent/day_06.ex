defmodule Advent.Day06 do
  @moduledoc """
  Day 06
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    solve(input, 4)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    solve(input, 14)
  end

  def solve(input, length) do
    input
    |> parse()
    |> Stream.chunk_every(length, 1, :discard)
    |> Stream.with_index()
    |> Enum.find(fn {chars, _index} -> Enum.uniq(chars) == chars end)
    |> then(fn {_chars, index} -> index + length end)
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.graphemes()
  end
end
