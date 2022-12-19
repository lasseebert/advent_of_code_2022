defmodule Advent.Day19 do
  @moduledoc """
  Day 19
  """

  @type blueprint :: {id :: pos_integer, [robot_cost]}
  @type robot_cost :: %{material => costs}
  @type costs :: [cost]
  @type cost :: %{material => amount :: pos_integer}
  @type material :: :ore | :clay | :obsidian | :geode

  @doc """
  Part 1

  Determine the quality level of each blueprint using the largest number of geodes it could produce in 24 minutes. What
  do you get if you add up the quality level of all of the blueprints in your list?

  Runs in ~0.7 seconds
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.map(fn {id, robot_costs} ->
      geodes = run(robot_costs, 24)
      geodes * id
    end)
    |> Enum.sum()
  end

  @doc """
  Part 2

  Don't worry about quality levels; instead, just determine the largest number of geodes you could open using each of
  the first three blueprints. What do you get if you multiply these numbers together?

  Runs in ~0.9 seconds
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> Enum.take(3)
    |> Enum.map(fn {_id, robot_costs} -> run(robot_costs, 32) end)
    |> Enum.reduce(&(&1 * &2))
  end

  defp run(robot_costs, time_left) do
    init_state = build_state(robot_costs, time_left)
    max_geodes(init_state, 0)
  end

  defp build_state(robot_costs, time_left) do
    %{
      materials: %{
        ore: 0,
        clay: 0,
        obsidian: 0,
        geode: 0
      },
      robots: %{
        ore: 1,
        clay: 0,
        obsidian: 0,
        geode: 0
      },
      time_left: time_left,
      robot_costs: robot_costs,
      building: nil
    }
  end

  defp max_geodes(%{time_left: 0} = state, _max), do: state.materials.geode

  defp max_geodes(state, max) do
    # This comparison and early exit is the single most important thing for performance
    if max >= theoretical_max(state) do
      max
    else
      state
      |> possible_next_builds()
      |> Enum.reduce(max, fn next_build, max ->
        state
        |> next(next_build)
        |> max_geodes(max)
        |> then(&Enum.max([&1, max]))
      end)
    end
  end

  defp theoretical_max(state) do
    # Pretend we can buy geode bots in all turns from now
    state.materials.geode + state.robots.geode * state.time_left + div(state.time_left * (state.time_left - 1), 2)
  end

  defp next(state, robot) do
    state
    |> do_build(robot)
    |> case do
      {:ok, state} ->
        state
        |> pass_time()
        |> then(&%{&1 | building: nil, robots: Map.update!(&1.robots, &1.building, fn count -> count + 1 end)})

      :error ->
        # This means we can't build the robot yet. Wait another turn
        state
        |> pass_time()
        |> case do
          %{time_left: 0} = state -> state
          state -> next(state, robot)
        end
    end
  end

  defp do_build(state, robot) do
    materials =
      state.robot_costs
      |> Map.fetch!(robot)
      |> Enum.reduce(state.materials, fn {material, amount}, materials ->
        Map.update!(materials, material, &(&1 - amount))
      end)

    materials
    |> Enum.any?(fn {_, amount} -> amount < 0 end)
    |> case do
      true -> :error
      false -> {:ok, %{state | materials: materials, building: robot}}
    end
  end

  defp can_afford?(state, robot) do
    case do_build(state, robot) do
      {:ok, _state} -> true
      :error -> false
    end
  end

  defp pass_time(state) do
    materials =
      Enum.reduce(state.robots, state.materials, fn {robot, amount}, materials ->
        Map.update!(materials, robot, &(&1 + amount))
      end)

    %{state | materials: materials, time_left: state.time_left - 1}
  end

  # This function is important for performance to reduce branching
  defp possible_next_builds(state) do
    # Whenever possible, we should build geode robots
    if can_afford?(state, :geode) do
      [:geode]
    else
      materials = [:ore, :clay, :obsidian, :geode]

      # It never makes sense to buy ore robots when we make more ore per turn that we can spend
      materials =
        if state.robots.ore >=
             Enum.max([
               state.robot_costs.clay.ore,
               state.robot_costs.obsidian.ore,
               state.robot_costs.geode.ore
             ]) do
          materials -- [:ore]
        else
          materials
        end

      # Same with clay
      materials =
        if state.robots.clay >= state.robot_costs.obsidian.clay do
          materials -- [:clay]
        else
          materials
        end

      # Same with obsidian. Notice we only use clay for obsidian
      materials =
        if state.robots.obsidian >=
             Enum.max([
               state.robot_costs.geode.obsidian
             ]) do
          materials -- [:obsidian, :clay]
        else
          materials
        end

      materials
    end
  end

  @spec parse(String.t()) :: [blueprint]
  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_blueprint/1)
  end

  defp parse_blueprint(line) do
    [header, body] = String.split(line, ": ")

    id = parse_id(header)
    costs = parse_costs(body)
    {id, costs}
  end

  defp parse_id(header) do
    [id] = Regex.run(~r/^Blueprint (\d+)$/, header, capture: :all_but_first)
    String.to_integer(id)
  end

  defp parse_costs(line) do
    line
    |> String.split(~r/\. ?/, trim: true)
    |> Enum.into(%{}, &parse_cost/1)
  end

  defp parse_cost(line) do
    [robot, cost] = String.split(line, ["Each ", " robot costs "], trim: true)
    robot = parse_material(robot)

    cost =
      cost
      |> String.split(" and ")
      |> Enum.into(%{}, fn cost_string ->
        [amount, material] = String.split(cost_string, " ")
        amount = String.to_integer(amount)
        material = parse_material(material)
        {material, amount}
      end)

    {robot, cost}
  end

  defp parse_material("ore"), do: :ore
  defp parse_material("clay"), do: :clay
  defp parse_material("obsidian"), do: :obsidian
  defp parse_material("geode"), do: :geode
end
