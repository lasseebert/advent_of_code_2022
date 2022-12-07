defmodule Advent.Day07 do
  @moduledoc """
  Day 07
  """

  alias Advent.Day07.FileTree

  @doc """
  Part 1

  Find all of the directories with a total size of at most 100000. What is the sum of the total sizes of those
  directories?
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    tree = parse(input)

    tree
    |> FileTree.dirs()
    |> Enum.map(&FileTree.size(tree, &1))
    |> Enum.filter(&(&1 < 100_000))
    |> Enum.sum()
  end

  @doc """
  Part 2

  The total disk space available to the filesystem is 70000000. To run the
  update, you need unused space of at least 30000000.

  Find the smallest directory that, if deleted, would free up enough space on
  the filesystem to run the update. What is the total size of that directory?
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    tree = parse(input)

    total_used_size = FileTree.size(tree, ["/"])
    available = 70_000_000
    needed = 30_000_000
    free = available - total_used_size
    need_to_delete = needed - free

    tree
    |> FileTree.dirs()
    |> Enum.map(&FileTree.size(tree, &1))
    |> Enum.filter(&(&1 >= need_to_delete))
    |> Enum.min()
  end

  defp parse(input) do
    tokens = tokenize(input)
    current_path = []

    {nodes, _current_path} =
      Enum.flat_map_reduce(tokens, current_path, fn token, current_path ->
        case token do
          {:cd, "/"} -> {[], ["/"]}
          {:cd, ".."} -> {[], Enum.drop(current_path, 1)}
          {:cd, name} -> {[], [name | current_path]}
          :ls -> {[], current_path}
          {:dir, name} -> {[{[name | current_path], :dir, nil}], current_path}
          {:file, name, size} -> {[{[name | current_path], :file, size}], current_path}
        end
      end)

    nodes = [{["/"], :dir, nil} | nodes]
    FileTree.new(nodes)
  end

  defp tokenize(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      cond do
        String.starts_with?(line, "$ cd ") -> {:cd, String.slice(line, 5..-1)}
        String.starts_with?(line, "dir ") -> {:dir, String.slice(line, 4..-1)}
        line == "$ ls" -> :ls
        true -> tokenize_file(line)
      end
    end)
  end

  defp tokenize_file(line) do
    [size, name] = Regex.run(~r/^(\d+) (.*)$/, line, capture: :all_but_first)
    size = String.to_integer(size)
    {:file, name, size}
  end
end
