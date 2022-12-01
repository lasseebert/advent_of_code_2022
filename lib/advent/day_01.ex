defmodule Advent.Day01 do
  @moduledoc """
  Day 01
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.map(&Enum.sum/1)
    |> Enum.max()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.chunk_while(
      [],
      fn
        "", acc -> {:cont, acc, []}
        elem, acc -> {:cont, [elem | acc]}
      end,
      fn
        acc -> {:cont, acc, []}
      end
    )
    |> Enum.map(fn list ->
      list
      |> Enum.reverse()
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
