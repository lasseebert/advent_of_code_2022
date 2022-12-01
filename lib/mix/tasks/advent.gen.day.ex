defmodule Mix.Tasks.Advent.Gen.Day do
  @moduledoc """
  Creates code file, test file and input file for a day
  """

  use Mix.Task

  alias IO.ANSI

  @impl Mix.Task
  def run(args) do
    day = parse_args!(args)

    [
      {"templates/puzzle_text.txt.eex", "puzzle_texts/day_#{day}.txt"},
      {"templates/puzzle_input.txt.eex", "puzzle_inputs/day_#{day}.txt"},
      {"templates/day.ex.eex", "lib/advent/day_#{day}.ex"},
      {"templates/day_test.exs.eex", "test/advent/day_#{day}_test.exs"}
    ]
    |> Enum.map(fn {template, output} ->
      if File.exists?(output) do
        Mix.raise("File already exists: #{output}. Aborting!")
      end

      {template, output}
    end)
    |> Enum.each(fn {template, output} ->
      IO.puts([ANSI.green(), "* Creating ", ANSI.reset(), output])
      output |> Path.dirname() |> File.mkdir_p!()
      template |> EEx.eval_file(day: day) |> (&File.write!(output, &1)).()
    end)
  end

  defp parse_args!(args) do
    case args do
      [num] ->
        if num =~ ~r/^\d{2}$/ do
          {:ok, num}
        else
          :error
        end

      _ ->
        :error
    end
    |> case do
      {:ok, num} -> num
      :error -> Mix.raise("Usage: mix advent.gen.day xx")
    end
  end
end
