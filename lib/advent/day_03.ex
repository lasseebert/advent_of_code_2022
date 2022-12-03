defmodule Advent.Day03 do
  @moduledoc """
  Day 03
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.map(&Enum.split(&1, div(length(&1), 2)))
    |> Enum.map(fn {comp_1, comp_2} ->
      comp_2_set = MapSet.new(comp_2)

      comp_1
      |> Enum.find(&(&1 in comp_2_set))
      |> score()
    end)
    |> Enum.sum()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> Enum.chunk_every(3)
    |> Enum.map(fn [elf_1, elf_2, elf_3] ->
      elf_2_set = MapSet.new(elf_2)
      elf_3_set = MapSet.new(elf_3)

      elf_1
      |> Enum.find(&(&1 in elf_2_set and &1 in elf_3_set))
      |> score()
    end)
    |> Enum.sum()
  end

  def score(item) do
    ascii = :binary.first(item)

    cond do
      ascii in ?a..?z -> ascii - ?a + 1
      ascii in ?A..?Z -> ascii - ?A + 27
    end
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end
end
