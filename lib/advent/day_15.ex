defmodule Advent.Day15 do
  @moduledoc """
  Day 15
  """

  @doc """
  Part 1

  Consult the report from the sensors you just deployed. In the row where y=2000000, how many positions cannot contain
  a beacon?
  """
  @spec part_1(String.t(), integer) :: integer
  def part_1(input, row_of_interest) do
    map = parse(input)

    beacons_on_row =
      map |> Enum.map(&elem(&1, 1)) |> Enum.uniq() |> Enum.filter(fn {_x, y} -> y == row_of_interest end)

    map
    # Find ranges of row coords for each sensor
    |> Enum.flat_map(fn {{sensor_x, sensor_y} = sensor, beacon} ->
      distance_to_beacon = distance(sensor, beacon)
      distance_to_row = distance(sensor_y, row_of_interest)

      if distance_to_row > distance_to_beacon do
        []
      else
        # When there is less distance to row than to beacon, there will be some row coords that are within the
        # diamond-shaped square of empty coords around the sensor.
        # They will be symmetric around the x of the sensor and span the extra distance in both directions
        extra_distance = distance_to_beacon - distance_to_row
        [{sensor_x - extra_distance, sensor_x + extra_distance}]
      end
    end)
    # Reduce the ranges to combined ranges that do not overlap
    |> Enum.sort()
    |> Enum.reduce([], fn
      range, [] -> [range]
      {a1, b1}, [{a2, b2} | combined] when a1 <= b2 + 1 -> [{a2, Enum.max([b1, b2])} | combined]
      range, combined -> [range | combined]
    end)
    # Find number of empty coords in each range - excluding any beacon that might be there
    |> Enum.map(fn {a, b} ->
      range = a..b
      num_beacons = beacons_on_row |> Enum.count(fn {x, y} -> x in range and y == row_of_interest end)
      b - a + 1 - num_beacons
    end)
    |> Enum.sum()
  end

  @doc """
  Part 2

  Find the only possible position for the distress beacon. What is its tuning frequency?

  It's not pretty or fast. Runs in around 7.5 seconds on my machine.
  """
  @spec part_2(String.t(), integer) :: integer
  def part_2(input, max) do
    map = parse(input)

    # Init all coords as ranges in rows
    rows = Enum.map(0..max, &{&1, [{0, max}]})

    map
    # Use largest sensor areas first for performance
    |> Enum.sort_by(fn {sensor, beacon} -> distance(sensor, beacon) * -1 end)
    |> Enum.reduce(rows, fn {{sensor_x, sensor_y} = sensor, beacon}, rows ->
      distance_to_beacon = distance(sensor, beacon)

      # Ranges in rows that this sensor covers
      covered =
        for y <- (sensor_y - distance_to_beacon)..(sensor_y + distance_to_beacon) do
          dist = sensor_y |> distance(y) |> distance(distance_to_beacon)
          {y, {sensor_x - dist, sensor_x + dist}}
        end

      # Subtract from existing ranges
      sub(rows, covered)
    end)
    # Only 1 range of length 1 left
    |> then(fn [{y, [{x, x}]}] -> x * 4_000_000 + y end)
  end

  defp distance({x1, y1}, {x2, y2}), do: distance(x1, x2) + distance(y1, y2)
  defp distance(a, b), do: abs(a - b)

  defp sub([{ry, _} = r | rs], [{cy, _} | cs]) when cy < ry, do: sub([r | rs], cs)
  defp sub([{ry, _} = r | rs], [{cy, _} | _] = cs) when cy > ry, do: [r | sub(rs, cs)]
  defp sub(rows, []), do: rows
  defp sub([], _), do: []

  defp sub([{ry, ranges} | rs], [{cy, c_range} | cs]) when cy == ry do
    ranges
    |> remove_from_ranges(c_range)
    |> case do
      [] -> sub(rs, cs)
      ranges -> [{ry, ranges} | sub(rs, cs)]
    end
  end

  defp remove_from_ranges(ranges, to_remove) do
    Enum.flat_map(ranges, fn range -> remove_from_range(range, to_remove) end)
  end

  defp remove_from_range({a1, b1}, {a2, b2}) do
    cond do
      b2 < a1 or a2 > b1 -> [{a1, b1}]
      a2 <= a1 and b2 >= b1 -> []
      a2 > a1 and b2 >= b1 -> [{a1, a2 - 1}]
      a2 <= a1 and b2 < b1 -> [{b2 + 1, b1}]
      a2 > a1 and b2 < b1 -> [{a1, a2 - 1}, {b2 + 1, b1}]
    end
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(["Sensor at x=", ", y=", ": closest beacon is at x="], trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> Enum.map(&List.to_tuple/1)
      |> List.to_tuple()
    end)
  end
end
