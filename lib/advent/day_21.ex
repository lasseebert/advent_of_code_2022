defmodule Advent.Day21 do
  @moduledoc """
  Day 21
  """

  @doc """
  Part 1

  However, your actual situation involves considerably more monkeys. What number will the monkey named root yell?
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> resolve_expression("root")
    |> calc()
  end

  @doc """
  Part 2

  What number do you yell to pass root's equality test?
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> Map.update!("root", fn {_op, a, b} -> {:=, a, b} end)
    |> Map.update!("humn", fn _ -> :human end)
    |> resolve_expression("root")
    |> solve()
  end

  defp solve({:=, a, b}) do
    unknown_in_a = unknown?(a)
    unknown_in_b = unknown?(b)

    {a, b} =
      case {unknown_in_a, unknown_in_b} do
        {true, false} -> {a, b}
        {false, true} -> {b, a}
      end

    b = calc(b)

    case a do
      :human ->
        b

      {op, left, right} when op in [:+, :*] ->
        case {unknown?(left), unknown?(right)} do
          {true, false} -> solve({:=, left, {reverse_op(op), b, right}})
          {false, true} -> solve({:=, right, {reverse_op(op), b, left}})
        end

      {:/ = op, left, right} ->
        case {unknown?(left), unknown?(right)} do
          {true, false} -> solve({:=, left, {reverse_op(op), b, right}})
        end

      {:- = op, left, right} ->
        case {unknown?(left), unknown?(right)} do
          {true, false} -> solve({:=, left, {reverse_op(op), b, right}})
          {false, true} -> solve({:=, right, {:*, -1, {:-, b, left}}})
        end
    end
  end

  defp calc(int) when is_integer(int), do: int
  defp calc({:+, a, b}), do: calc(a) + calc(b)
  defp calc({:-, a, b}), do: calc(a) - calc(b)
  defp calc({:*, a, b}), do: calc(a) * calc(b)
  defp calc({:/, a, b}), do: div(calc(a), calc(b))

  defp reverse_op(:+), do: :-
  defp reverse_op(:-), do: :+
  defp reverse_op(:*), do: :/
  defp reverse_op(:/), do: :*

  defp unknown?(:human), do: true
  defp unknown?(int) when is_integer(int), do: false
  defp unknown?({_op, a, b}), do: unknown?(a) or unknown?(b)

  defp resolve_expression(monkeys, name) do
    case Map.fetch!(monkeys, name) do
      int when is_integer(int) ->
        int

      :human ->
        :human

      {op, a, b} ->
        {
          op,
          resolve_expression(monkeys, a),
          resolve_expression(monkeys, b)
        }
    end
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.into(%{}, fn line ->
      [name, expression] = String.split(line, ": ")

      expression =
        expression
        |> String.split(" ")
        |> case do
          [int] -> String.to_integer(int)
          [a, op, b] -> {parse_operator(op), a, b}
        end

      {name, expression}
    end)
  end

  defp parse_operator("+"), do: :+
  defp parse_operator("-"), do: :-
  defp parse_operator("*"), do: :*
  defp parse_operator("/"), do: :/
end
