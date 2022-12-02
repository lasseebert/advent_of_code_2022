defmodule Advent.Day02 do
  @moduledoc """
  Day 02
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse(:part_1)
    |> Enum.map(&score/1)
    |> Enum.sum()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse(:part_2)
    |> Enum.map(fn {other, me} -> {other, find_hand({other, me})} end)
    |> Enum.map(&score/1)
    |> Enum.sum()
  end

  defp find_hand({other, :draw}), do: other
  defp find_hand({:rock, :win}), do: :paper
  defp find_hand({:paper, :win}), do: :scissors
  defp find_hand({:scissors, :win}), do: :rock
  defp find_hand({:rock, :lose}), do: :scissors
  defp find_hand({:paper, :lose}), do: :rock
  defp find_hand({:scissors, :lose}), do: :paper

  defp score({other, me}) do
    outcome =
      case {other, me} do
        {a, a} -> 3
        {:rock, :paper} -> 6
        {:paper, :scissors} -> 6
        {:scissors, :rock} -> 6
        _ -> 0
      end

    hand =
      case me do
        :rock -> 1
        :paper -> 2
        :scissors -> 3
      end

    outcome + hand
  end

  defp parse(input, part) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ")
      |> Enum.map(&parse_char(part, &1))
      |> List.to_tuple()
    end)
  end

  defp parse_char(:part_1, "A"), do: :rock
  defp parse_char(:part_1, "B"), do: :paper
  defp parse_char(:part_1, "C"), do: :scissors
  defp parse_char(:part_1, "X"), do: :rock
  defp parse_char(:part_1, "Y"), do: :paper
  defp parse_char(:part_1, "Z"), do: :scissors

  defp parse_char(:part_2, "A"), do: :rock
  defp parse_char(:part_2, "B"), do: :paper
  defp parse_char(:part_2, "C"), do: :scissors
  defp parse_char(:part_2, "X"), do: :lose
  defp parse_char(:part_2, "Y"), do: :draw
  defp parse_char(:part_2, "Z"), do: :win
end
