defmodule Advent.Day11 do
  @moduledoc """
  Day 11
  """

  @doc """
  Part 1

  Figure out which monkeys to chase by counting how many items they inspect over 20 rounds. What is the level of monkey
  business after 20 rounds of stuff-slinging simian shenanigans?
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> play_rounds(20, :part_1)
    |> monkey_business_level()
  end

  @doc """
  Part 2

  Worry levels are no longer divided by three after each item is inspected; you'll need to find another way to keep
  your worry levels manageable. Starting again from the initial state in your puzzle input, what is the level of monkey
  business after 10000 rounds?
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    monkeys = parse(input)
    product = monkeys |> Map.values() |> Enum.map(& &1.test_divisible_by) |> Enum.reduce(&(&1 * &2))

    monkeys
    |> play_rounds(10_000, {:part_2, product})
    |> monkey_business_level()
  end

  defp play_rounds(monkeys, 0, _part), do: monkeys

  defp play_rounds(monkeys, n, part) when n > 0 do
    monkeys
    |> play_round(part)
    |> play_rounds(n - 1, part)
  end

  defp play_round(monkeys, part) do
    monkeys
    |> Map.keys()
    |> Enum.sort()
    |> Enum.reduce(monkeys, &play_monkey(&2, &1, part))
  end

  defp play_monkey(monkeys, current_number, part) do
    source_monkey = Map.fetch!(monkeys, current_number)

    monkeys =
      source_monkey.items
      |> Enum.reduce(monkeys, fn item, monkeys ->
        item = do_operation(source_monkey.operation, item)
        item = bored(item, part)
        test_result = run_test(source_monkey.test_divisible_by, item)
        target_monkey_number = if test_result, do: source_monkey.true_monkey, else: source_monkey.false_monkey

        target_monkey = Map.fetch!(monkeys, target_monkey_number)
        target_monkey = %{target_monkey | items: [item | target_monkey.items]}

        Map.put(monkeys, target_monkey_number, target_monkey)
      end)

    source_monkey = %{
      source_monkey
      | inspect_count: source_monkey.inspect_count + length(source_monkey.items),
        items: []
    }

    Map.put(monkeys, current_number, source_monkey)
  end

  defp bored(item, part) do
    case part do
      :part_1 -> div(item, 3)
      {:part_2, product} -> rem(item, product)
    end
  end

  defp do_operation([:old, :*, b], item), do: item * evaluate(b, item)
  defp do_operation([:old, :+, b], item), do: item + evaluate(b, item)

  defp evaluate(:old, item), do: item
  defp evaluate(int, _item) when is_integer(int), do: int

  defp run_test(divisible_by, item), do: rem(item, divisible_by) == 0

  defp monkey_business_level(monkeys) do
    monkeys
    |> Map.values()
    |> Enum.map(& &1.inspect_count)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> then(fn [i1, i2] -> i1 * i2 end)
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn section ->
      [_header, starting_items, operation, test, true_branch, false_branch] = String.split(section, "\n", trim: true)

      starting_items = parse_starting_items(starting_items)
      operation = parse_operation(operation)
      test = parse_test(test)
      true_branch = parse_true_branch(true_branch)
      false_branch = parse_false_branch(false_branch)

      %{
        items: starting_items,
        operation: operation,
        test_divisible_by: test,
        true_monkey: true_branch,
        false_monkey: false_branch,
        inspect_count: 0
      }
    end)
    |> Enum.with_index()
    |> Enum.into(%{}, fn {monkey, index} -> {index, monkey} end)
  end

  defp parse_starting_items(line) do
    <<"  Starting items: ", starting_items::binary>> = line
    starting_items |> String.split(", ") |> Enum.map(&String.to_integer/1)
  end

  defp parse_operation(line) do
    <<"  Operation: new = ", operation::binary>> = line

    operation
    |> String.split(" ")
    |> Enum.map(fn value ->
      cond do
        value == "old" -> :old
        value == "*" -> :*
        value == "+" -> :+
        Regex.match?(~r/^\d+$/, value) -> String.to_integer(value)
      end
    end)
  end

  defp parse_test(line) do
    <<"  Test: divisible by ", test::binary>> = line
    String.to_integer(test)
  end

  defp parse_true_branch(line) do
    <<"    If true: throw to monkey ", true_branch::binary>> = line
    String.to_integer(true_branch)
  end

  defp parse_false_branch(line) do
    <<"    If false: throw to monkey ", false_branch::binary>> = line
    String.to_integer(false_branch)
  end
end
