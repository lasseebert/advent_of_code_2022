defmodule Advent.Day10 do
  @moduledoc """
  Day 10
  """

  @doc """
  Part 1

  Find the signal strength during the 20th, 60th, 100th, 140th, 180th, and 220th cycles. What is the sum of these six
  signal strengths?
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> sprite_pos_stream()
    |> Stream.with_index()
    |> Enum.take(220)
    |> Enum.drop(19)
    |> Enum.chunk_every(40)
    |> Enum.map(&hd/1)
    |> Enum.map(fn {register, index} -> (index + 1) * register end)
    |> Enum.sum()
  end

  @doc """
  Part 2

  Render the image given by your program. What eight capital letters appear on your CRT?
  """
  @spec part_2(String.t()) :: String.t()
  def part_2(input) do
    input
    |> parse()
    |> sprite_pos_stream()
    |> Stream.with_index()
    |> Enum.take(240)
    |> Enum.chunk_every(40)
    |> Enum.map(fn chunk ->
      chunk
      |> Enum.map(fn {sprite_pos, index} ->
        x = rem(index, 40)

        if abs(x - sprite_pos) <= 1 do
          "#"
        else
          "."
        end
      end)
      |> Enum.join()
    end)
    |> Enum.join("\n")
    |> then(fn render -> render <> "\n" end)
  end

  defp sprite_pos_stream(program) do
    state = %{
      program: program,
      register: 1,
      cycles: 0
    }

    Stream.iterate(state, fn state ->
      [operation | new_program] = state.program

      {new_register, new_cycles} =
        case operation do
          :noop -> {state.register, state.cycles + 1}
          {:addx, value} -> {state.register + value, state.cycles + 2}
        end

      %{state | program: new_program, register: new_register, cycles: new_cycles}
    end)
    |> Stream.map(&{&1.cycles, &1.register})
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.flat_map(fn [{c1, r1}, {c2, _r2}] ->
      if c2 == c1 + 2 do
        [r1, r1]
      else
        [r1]
      end
    end)
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&tokenize/1)
  end

  defp tokenize(line) do
    cond do
      line == "noop" -> :noop
      String.starts_with?(line, "addx ") -> {:addx, line |> String.slice(5..-1) |> String.to_integer()}
    end
  end
end
