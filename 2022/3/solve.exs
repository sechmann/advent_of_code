defmodule Solve do
  def flatsum(setsList) do
    setsList
    |> Enum.map(&MapSet.to_list/1)
    |> List.flatten()
    |> Enum.sum()
  end

  def p1(lines) do
    lines
    |> Stream.map(fn l -> Enum.split(l, div(length(l), 2)) end)
    |> Stream.map(fn {a, b} ->
      MapSet.intersection(
        MapSet.new(a),
        MapSet.new(b)
      )
    end)
    |> flatsum
  end

  def p2(lines) do
    lines
    |> Stream.chunk_every(3)
    |> Stream.map(fn [l1, l2, l3] ->
      MapSet.intersection(
        MapSet.new(l1),
        MapSet.intersection(
          MapSet.new(l2),
          MapSet.new(l3)
        )
      )
    end)
    |> flatsum
  end
end

convert = fn c ->
  if c >= ?a do
    c - ?a + 1
  else
    c - ?A + 1 + 26
  end
end

lines =
  IO.stream(:stdio, :line)
  |> Stream.map(&String.trim/1)
  |> Enum.map(&String.to_charlist/1)
  |> Enum.map(fn l -> Enum.map(l, convert) end)

IO.puts("p1: " <> to_string(Solve.p1(lines)))
IO.puts("p2: " <> to_string(Solve.p2(lines)))
