defmodule Advent.Day13 do
  @moduledoc """
  Day 13
  """

  @doc """
  Part 1

  Determine which pairs of packets are already in the right order. What is the sum of the indices of those pairs?
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.with_index()
    |> Enum.filter(fn {{left, right}, _index} -> ordered?(left, right) end)
    |> Enum.map(fn {_pair, index} -> index + 1 end)
    |> Enum.sum()
  end

  @doc """
  Part 2

  Organize all of the packets into the correct order. What is the decoder key for the distress signal?
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    markers = [[[2]], [[6]]]

    input
    |> parse()
    |> Enum.flat_map(fn {left, right} -> [left, right] end)
    |> then(&(markers ++ &1))
    |> Enum.sort(&ordered?/2)
    |> Enum.with_index()
    |> Enum.filter(fn {item, _index} -> item in markers end)
    |> Enum.map(fn {_item, index} -> index + 1 end)
    |> then(fn [a, b] -> a * b end)
  end

  defp ordered?(a, b), do: compare(a, b) == :lt

  defp compare(a, b) when is_integer(a) and is_integer(b) and a < b, do: :lt
  defp compare(a, b) when is_integer(a) and is_integer(b) and a > b, do: :gt
  defp compare(a, b) when is_integer(a) and is_integer(b) and a == b, do: :eq
  defp compare([], [_ | _]), do: :lt
  defp compare([_ | _], []), do: :gt
  defp compare([], []), do: :eq
  defp compare(a, b) when is_list(a) and is_integer(b), do: compare(a, [b])
  defp compare(a, b) when is_integer(a) and is_list(b), do: compare([a], b)

  defp compare([a | as], [b | bs]) do
    case compare(a, b) do
      :lt -> :lt
      :gt -> :gt
      :eq -> compare(as, bs)
    end
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn pair ->
      pair
      |> String.split("\n", trim: true)
      |> Enum.map(&list_from_string/1)
      |> List.to_tuple()
    end)
  end

  defp list_from_string(string) do
    {list, []} =
      string
      |> tokenize()
      |> list_from_tokens()

    list
  end

  defp list_from_tokens([:start | tokens]) do
    read_list(tokens, [])
  end

  defp read_list([{:int, n} | tokens], acc), do: read_list(tokens, [n | acc])

  defp read_list([:start | tokens], acc) do
    {inner_list, tokens} = read_list(tokens, [])
    read_list(tokens, [inner_list | acc])
  end

  defp read_list([:end | tokens], acc), do: {Enum.reverse(acc), tokens}

  defp tokenize(input) do
    input
    |> String.graphemes()
    |> Enum.reduce([], fn
      "[", acc -> [:start | acc]
      "]", acc -> [:end | acc]
      ",", acc -> [:comma | acc]
      int, [{:int, n} | acc] -> [{:int, n * 10 + String.to_integer(int)} | acc]
      int, acc -> [{:int, String.to_integer(int)} | acc]
    end)
    |> Enum.reverse()
    |> Enum.reject(&(&1 == :comma))
  end
end
