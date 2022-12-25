defmodule Advent.Day25 do
  @moduledoc """
  Day 25
  """

  @doc """
  Part 1

  The Elves are starting to get cold. What SNAFU number do you supply to Bob's console?
  """
  @spec part_1(String.t()) :: String.t()
  def part_1(input) do
    input
    |> parse()
    |> Enum.map(&snafu_to_dec/1)
    |> Enum.sum()
    |> dec_to_snafu()
  end

  defp snafu_to_dec(snafu) do
    snafu
    |> String.graphemes()
    |> Enum.reverse()
    |> Enum.map_reduce(1, fn digit, place -> {snafu_digit_to_dec(digit) * place, place * 5} end)
    |> elem(0)
    |> Enum.sum()
  end

  defp dec_to_snafu(value) do
    value
    |> Integer.to_string(5)
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.reverse()
    |> Enum.map_reduce(0, fn digit, mem ->
      digit = digit + mem

      if digit >= 3 do
        {digit - 5, 1}
      else
        {digit, 0}
      end
    end)
    |> elem(0)
    |> Enum.reverse()
    |> Enum.map(&dec_to_snafu_digit/1)
    |> Enum.join()
  end

  defp snafu_digit_to_dec("="), do: -2
  defp snafu_digit_to_dec("-"), do: -1
  defp snafu_digit_to_dec("0"), do: 0
  defp snafu_digit_to_dec("1"), do: 1
  defp snafu_digit_to_dec("2"), do: 2

  defp dec_to_snafu_digit(-2), do: "="
  defp dec_to_snafu_digit(-1), do: "-"
  defp dec_to_snafu_digit(0), do: "0"
  defp dec_to_snafu_digit(1), do: "1"
  defp dec_to_snafu_digit(2), do: "2"

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
  end
end
