defmodule Advent.Day05 do
  @moduledoc """
  Day 05
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: String.t()
  def part_1(input) do
    solve(:single, input)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: String.t()
  def part_2(input) do
    solve(:multi, input)
  end

  def solve(strategy, input) do
    {crates, moves} = parse(input)

    moves
    |> Enum.reduce(crates, &run_move(strategy, &1, &2))
    |> read_top_crates()
  end

  def run_move(strategy, move, crates) do
    source = Map.fetch!(crates, move.source)
    dest = Map.fetch!(crates, move.destination)

    top_crates =
      source
      |> Enum.take(move.amount)
      |> then(fn crates ->
        case strategy do
          :single -> Enum.reverse(crates)
          :multi -> crates
        end
      end)

    dest = top_crates ++ dest
    source = Enum.drop(source, move.amount)

    crates
    |> Map.put(move.source, source)
    |> Map.put(move.destination, dest)
  end

  defp read_top_crates(crates) do
    crates
    |> Enum.sort()
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(&List.first/1)
    |> Enum.join()
  end

  defp parse(input) do
    {crates, ["" | moves]} =
      input
      |> String.trim("\n")
      |> String.split("\n")
      |> Enum.split_while(&(&1 != ""))

    crates =
      crates
      |> Enum.take(length(crates) - 1)
      |> parse_crates()

    moves = Enum.map(moves, &parse_move/1)

    {crates, moves}
  end

  defp parse_crates(lines) do
    lines
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.chunk_every(4)
      |> Enum.map(&Enum.at(&1, 1))
    end)
    |> Enum.zip()
    |> Enum.map(&(&1 |> Tuple.to_list() |> Enum.reject(fn id -> id == " " end)))
    |> Enum.with_index()
    |> Enum.into(%{}, fn {stack, index} -> {index + 1, stack} end)
  end

  defp parse_move(line) do
    [amount, source, destination] =
      ~r/move (\d+) from (\d+) to (\d+)/
      |> Regex.run(line, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)

    %{
      amount: amount,
      source: source,
      destination: destination
    }
  end
end
