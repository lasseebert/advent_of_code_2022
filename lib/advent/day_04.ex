defmodule Advent.Day04 do
  @moduledoc """
  Day 04
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.filter(fn {range_1, range_2} -> any_cover?(range_1, range_2) end)
    |> length()
  end

  def any_cover?(range_1, range_2) do
    cover?(range_1, range_2) or cover?(range_2, range_1)
  end

  def cover?(range_1, range_2) do
    range_1.first <= range_2.first and range_1.last >= range_2.last
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> Enum.filter(fn {range_1, range_2} -> overlap?(range_1, range_2) end)
    |> length()
  end

  def overlap?(range_1, range_2) do
    range_1.last >= range_2.first && range_1.first <= range_2.last
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(fn range ->
        [first, last] =
          range
          |> String.split("-")
          |> Enum.map(&String.to_integer/1)

        first..last
      end)
      |> List.to_tuple()
    end)
  end
end
