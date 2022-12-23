defmodule Advent.Day22 do
  @moduledoc """
  Day 22
  """

  @doc """
  Part 1

  Follow the path given in the monkeys' notes. What is the final password?
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    {map, commands} = parse(input)

    map
    |> start_pos()
    |> walk(commands, map, :flat)
    |> password()
  end

  @doc """
  Part 2

  Fold the map into a cube, then follow the path given in the monkeys' notes. What is the final password?
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    {map, commands} = parse(input)

    dice_size = map |> Map.keys() |> length() |> div(6) |> :math.sqrt() |> trunc()

    dice_map =
      map
      |> Map.keys()
      |> Enum.filter(fn {x, y} -> rem(x, dice_size) == 0 and rem(y, dice_size) == 0 end)
      |> Enum.map(fn {x, y} -> {div(x, dice_size), div(y, dice_size)} end)
      |> build_dice()

    dice_reverse_map = Enum.into(dice_map, %{}, fn {section, {side, turn}} ->
      {side, {section, turn}}
    end)

    dice = %{
      map: dice_map,
      reverse_map: dice_reverse_map,
      size: dice_size
    }

    map
    |> start_pos()
    |> walk(commands, map, {:dice, dice})
    |> password()
  end

  # This will return a map from section to dice side and orientation
  # The orientation is the map orientation relative to the dice orientation
  #
  # The dice is in a left-handed system
  # * X side: Y on the left, Z on top
  # * -X side: Y on the right, Z on top
  # * Y side: X on the right, Z on top
  # * -Y side: x on the left, Z on top
  # * Z side: Y on the left, X on bottom
  # * -Z side: Y on the left, X on top
  defp build_dice(sections) do
    [first | rest] = sections

    # We define the first section to be the X side of the dice
    dice = %{first => {{1, 0, 0}, 0}}

    build_dice(dice, rest)
  end

  defp build_dice(dice, []), do: dice

  defp build_dice(dice, [first | rest]) do
    [
      {-1, 0},
      {1, 0},
      {0, -1},
      {0, 1}
    ]
    |> Enum.find(&Map.has_key?(dice, add(&1, first)))
    |> case do
      nil ->
        # Wait until we have a neighbour
        build_dice(dice, rest ++ [first])

      dir ->
        neighbour_section = add(first, dir)
        neighbour_side = Map.fetch!(dice, neighbour_section)
        rev_dir = mult(dir, -1)
        side = move_side(neighbour_side, rev_dir)

        dice
        |> Map.put(first, side)
        |> build_dice(rest)
    end
  end

  defp move_side({{1, 0, 0}, 0}, {0, -1}), do: {{0, 0, 1}, 0}
  defp move_side({{1, 0, 0}, 0}, {-1, 0}), do: {{0, 1, 0}, 0}
  defp move_side({{-1, 0, 0}, 3}, {0, -1}), do: {{0, 1, 0}, 3}
  defp move_side({{-1, 0, 0}, 1}, {-1, 0}), do: {{0, 0, -1}, 3}
  defp move_side({{0, 1, 0}, 0}, {0, -1}), do: {{0, 0, 1}, 3}
  defp move_side({{0, 1, 0}, 3}, {1, 0}), do: {{0, 0, -1}, 0}
  defp move_side({{0, -1, 0}, 3}, {0, -1}), do: {{-1, 0, 0}, 3}
  defp move_side({{0, 0, 1}, 0}, {1, 0}), do: {{0, -1, 0}, 3}
  defp move_side({{0, 0, 1}, 3}, {0, -1}), do: {{0, -1, 0}, 2}
  defp move_side({{0, 0, 1}, 3}, {-1, 0}), do: {{-1, 0, 0}, 1}

  defp walk(pos, commands, map, type) do
    Enum.reduce(commands, pos, fn
      :turn_left, {coord, :east} -> {coord, :north}
      :turn_left, {coord, :north} -> {coord, :west}
      :turn_left, {coord, :west} -> {coord, :south}
      :turn_left, {coord, :south} -> {coord, :east}
      :turn_right, {coord, :east} -> {coord, :south}
      :turn_right, {coord, :north} -> {coord, :east}
      :turn_right, {coord, :west} -> {coord, :north}
      :turn_right, {coord, :south} -> {coord, :west}
      {:forward, amount}, pos -> walk_forward(pos, amount, map, type)
    end)
  end

  defp walk_forward(pos, amount, map, type) do
    Enum.reduce(1..amount, pos, fn _, pos ->
      {coord, _} = next_pos = find_next_pos(pos, map, type)

      case Map.fetch!(map, coord) do
        :space -> next_pos
        :rock -> pos
      end
    end)
  end

  defp find_next_pos({coord, heading} = pos, map, type) do
    dir =
      case heading do
        :east -> {1, 0}
        :north -> {0, -1}
        :west -> {-1, 0}
        :south -> {0, 1}
      end

    next = add(coord, dir)

    if Map.has_key?(map, next) do
      {next, heading}
    else
      wrap_map(pos, map, type)
    end
  end

  defp wrap_map({{x, y}, heading}, map, :flat) do
    heading
    |> case do
      :east -> map |> Map.keys() |> Enum.filter(&(elem(&1, 1) == y)) |> Enum.min_by(&elem(&1, 0))
      :west -> map |> Map.keys() |> Enum.filter(&(elem(&1, 1) == y)) |> Enum.max_by(&elem(&1, 0))
      :south -> map |> Map.keys() |> Enum.filter(&(elem(&1, 0) == x)) |> Enum.min_by(&elem(&1, 1))
      :north -> map |> Map.keys() |> Enum.filter(&(elem(&1, 0) == x)) |> Enum.max_by(&elem(&1, 1))
    end
    |> then(&{&1, heading})
  end

  defp wrap_map({coord, heading}, _map, {:dice, dice}) do
    section = divide(coord, dice.size)
    {side, turn} = Map.fetch!(dice.map, section)

    {next_side, next_turn} = case {side, turn, heading} do
      {{1, 0, 0}, 0, :east} -> {{0, -1, 0}, 0}
      {{1, 0, 0}, 0, :south} -> {{0, 0, -1}, 0}
      {{1, 0, 0}, 0, :west} -> {{0, 1, 0}, 0}
      {{-1, 0, 0}, 1, :north} -> {{0, -1, 0}, 1}
      {{-1, 0, 0}, 3, :east} -> {{0, 0, -1}, 1}
      {{-1, 0, 0}, 3, :west} -> {{0, 0, 1}, 1}
      {{0, 1, 0}, 0, :south} -> {{0, 0, -1}, 1}
      {{0, 1, 0}, 3, :west} -> {{0, 0, 1}, 2}
      {{0, 1, 0}, 3, :north} -> {{1, 0, 0}, 3}
      {{0, -1, 0}, 3, :south} -> {{1, 0, 0}, 3}
      {{0, -1, 0}, 3, :east} -> {{0, 0, -1}, 2}
      {{0, 0, 1}, 0, :south} -> {{1, 0, 0}, 0}
      {{0, 0, 1}, 0, :west} -> {{0, 1, 0}, 1}
      {{0, 0, 1}, 0, :north} -> {{-1, 0, 0}, 2}
      {{0, 0, 1}, 3, :east} -> {{1, 0, 0}, 3}
      {{0, 0, -1}, 0, :north} -> {{1, 0, 0}, 0}
      {{0, 0, -1}, 0, :east} -> {{0, -1, 0}, 1}
      {{0, 0, -1}, 0, :south} -> {{-1, 0, 0}, 2}
      {{0, 0, -1}, 3, :west} -> {{1, 0, 0}, 3}
      {{0, 0, -1}, 3, :south} -> {{0, 1, 0}, 2}
    end

    {next_section, next_section_turn} = Map.fetch!(dice.reverse_map, next_side)

    combined_turn = rem(next_turn - next_section_turn + 4, 4)

    dice_coord = remain(coord, dice.size)
    next_dice_coord = case {dice_coord, heading} do
      {{_x, y}, :east} -> {0, y}
      {{_x, y}, :west} -> {dice.size - 1, y}
      {{x, _y}, :south} -> {x, 0}
      {{x, _y}, :north} -> {x, dice.size - 1}
    end

    next_dice_coord_turned = case {next_dice_coord, combined_turn} do
      {{x, y}, 0} -> {x, y}
      {{x, y}, 1} -> {y, dice.size - 1 - x}
      {{x, y}, 2} -> {dice.size - 1 - x, dice.size - 1 - y}
      {{x, y}, 3} -> {dice.size - 1 - y, x}
    end

    next_map_coord = next_section |> mult(dice.size) |> add(next_dice_coord_turned)
    next_heading = case {heading, combined_turn} do
      {heading, 0} -> heading
      {:east, 1} -> :north
      {:east, 2} -> :west
      {:east, 3} -> :south
      {:west, 1} -> :south
      {:west, 2} -> :east
      {:west, 3} -> :north
      {:south, 2} -> :north
      {:south, 3} -> :west
      {:north, 2} -> :south
      {:north, 3} -> :east
    end

    {next_map_coord, next_heading}
  end

  defp add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}
  defp mult({x, y}, a), do: {x * a, y * a}
  defp divide({x, y}, a), do: {div(x,  a), div(y, a)}
  defp remain({x, y}, a), do: {rem(x,  a), rem(y, a)}

  defp start_pos(map) do
    map
    |> Map.keys()
    |> Enum.filter(fn {_x, y} -> y == 0 end)
    |> Enum.min_by(fn {x, _y} -> x end)
    |> then(fn pos -> {pos, :east} end)
  end

  defp password({{x, y}, dir}) do
    dir_value =
      case dir do
        :east -> 0
        :south -> 1
        :west -> 2
        :north -> 3
      end

    1000 * (y + 1) + 4 * (x + 1) + dir_value
  end

  defp parse(input) do
    input
    |> String.split("\n\n")
    |> then(fn [map, commands] ->
      {
        parse_map(map),
        parse_commands(commands)
      }
    end)
  end

  defp parse_map(input) do
    input
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, map ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(map, fn
        {".", x}, map -> Map.put(map, {x, y}, :space)
        {"#", x}, map -> Map.put(map, {x, y}, :rock)
        {" ", _x}, map -> map
      end)
    end)
  end

  defp parse_commands(input) do
    input
    |> String.trim()
    |> String.split(~r/((?<=[RL])(?=[0-9]))|((?<=[0-9])(?=[RL]))/)
    |> Enum.map(fn
      "R" -> :turn_right
      "L" -> :turn_left
      int -> {:forward, String.to_integer(int)}
    end)
  end
end
