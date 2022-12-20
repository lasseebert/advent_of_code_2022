defmodule Advent.Day20 do
  @moduledoc """
  Day 20
  """

  @doc """
  Part 1

  Mix your encrypted file exactly once. What is the sum of the three numbers that form the
  grove coordinates?
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> mix(1)
    |> coordinates()
    |> then(fn {x, y, z} -> x + y + z end)
  end

  @doc """
  Part 2

  Apply the decryption key and mix your encrypted file ten times. What is the sum of the
  three numbers that form the grove coordinates?
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    decryption_key = 811_589_153

    input
    |> parse()
    |> Enum.map(&(&1 * decryption_key))
    |> mix(10)
    |> coordinates()
    |> then(fn {x, y, z} -> x + y + z end)
  end

  defp mix(list, count) do
    indexed = list |> Enum.with_index()

    1..count
    |> Enum.reduce(indexed, fn _, indexed ->
      indexed
      |> Enum.sort_by(fn {_val, index} -> index end)
      |> Enum.reduce(indexed, fn {val, _index} = item, indexed ->
        list_index = Enum.find_index(indexed, &(&1 == item))
        {first, [item | second]} = Enum.split(indexed, list_index)
        new_list = first ++ second

        len = length(new_list)
        new_index = rem(rem(list_index + val, len) + len, len)
        List.insert_at(new_list, new_index, item)
      end)
    end)
    |> Enum.map(fn {val, _index} -> val end)
  end

  defp coordinates(list) do
    len = length(list)
    zero = Enum.find_index(list, &(&1 == 0))

    {
      Enum.at(list, rem(zero + 1000, len)),
      Enum.at(list, rem(zero + 2000, len)),
      Enum.at(list, rem(zero + 3000, len))
    }
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
