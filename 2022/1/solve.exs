defmodule One do
  def p1(data) do
    data
    |> Enum.max
    |> IO.inspect
  end

  def p2(data) do
    data
    |> Enum.sort
    |> Enum.reverse
    |> Enum.take(3)
    |> Enum.sum
    |> IO.inspect
  end

  def group(stdin) do
    String.split(stdin, "\n\n")
    |> Stream.map(&String.split(&1, "\n"))
    |> Stream.map(&Stream.filter(&1, fn s -> (String.length s) > 0 end ))
    |> Stream.map(fn e -> Stream.map(e, &String.to_integer/1) end)
    |> Stream.map(&Enum.sum/1)
  end
end

grouped = One.group(IO.read(:stdio, :all))
One.p1(grouped)
One.p2(grouped)
