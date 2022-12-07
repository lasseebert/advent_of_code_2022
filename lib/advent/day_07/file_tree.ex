defmodule Advent.Day07.FileTree do
  @moduledoc """
  Data structure for a file tree with files and dirs
  """

  use TypedStruct

  typedstruct do
    field :nodes_map, %{path => item}
    field :children_map, %{path => [path]}
  end

  @type item :: {path, type, size}
  @type path :: [String.t()]
  @type type :: :dir | :file
  @type size :: pos_integer

  def new(nodes) do
    nodes_map = Enum.into(nodes, %{}, &{elem(&1, 0), &1})

    children_map =
      Enum.reduce(nodes, %{}, fn {[_ | parent] = path, _type, _size}, map ->
        Map.update(map, parent, [path], &[path | &1])
      end)

    %__MODULE__{
      nodes_map: nodes_map,
      children_map: children_map
    }
    |> calc_size(["/"])
  end

  @spec dirs(t) :: [path]
  def dirs(tree) do
    tree.nodes_map |> Map.values() |> Enum.filter(&match?({_, :dir, _}, &1)) |> Enum.map(&elem(&1, 0))
  end

  @spec size(t, path) :: size
  def size(tree, path) do
    {_path, _type, size} = Map.fetch!(tree.nodes_map, path)
    size
  end

  defp calc_size(tree, path) do
    case Map.fetch!(tree.nodes_map, path) do
      {^path, _, size} when is_integer(size) ->
        tree

      {^path, :dir, nil} ->
        {sizes, tree} =
          tree
          |> children(path)
          |> Enum.map_reduce(tree, fn child_path, tree ->
            tree = calc_size(tree, child_path)
            {size(tree, child_path), tree}
          end)

        size = Enum.reduce(sizes, 0, &(&1 + &2))
        nodes_map = Map.put(tree.nodes_map, path, {path, :dir, size})
        %{tree | nodes_map: nodes_map}
    end
  end

  defp children(tree, path) do
    Map.get(tree.children_map, path, [])
  end
end
