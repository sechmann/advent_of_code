defmodule Solve do
  def hand(c) do
    cond do
      c == "A" or c == "X" -> :rock
      c == "B" or c == "Y" -> :paper
      c == "C" or c == "Z" -> :scissors
    end
  end

  def strategy(c) do
    case c do
      "X" -> :lose
      "Y" -> :draw
      "Z" -> :win
    end
  end

  def play(opponent, me) do
    cond do
      opponent == me -> 3
      opponent == :scissors && me == :rock -> 6
      opponent == :paper && me == :scissors -> 6
      opponent == :rock && me == :paper -> 6
      true -> 0
    end
  end

  def use_strategy(hand, strategy) do
    case {strategy, hand} do
      {:lose, :rock}     -> :scissors
      {:lose, :paper}    -> :rock
      {:lose, :scissors} -> :paper
      {:draw, hand}      -> hand
      {:win,  :rock}     -> :paper
      {:win,  :paper}    -> :scissors
      {:win,  :scissors} -> :rock
    end
  end

  def p1(input) do
    Stream.map(input, fn g ->
        [opponent, me] = String.split(g)
        play(hand(opponent), hand(me))
      end
    )
    # |> IO.inspect
    |> Enum.sum
  end

  def p2(input) do
    Stream.map(input, fn g ->
        [opponent, me] = String.split(g)
        case {hand(opponent), strategy(me)} do
          {:rock,     :lose} -> 3 + 0
          {:rock,     :draw} -> 1 + 3
          {:rock,     :win}  -> 2 + 6
                                     
          {:paper,    :lose} -> 1 + 0
          {:paper,    :draw} -> 2 + 3
          {:paper,    :win}  -> 3 + 6
                                     
          {:scissors, :lose} -> 2 + 0
          {:scissors, :draw} -> 3 + 3
          {:scissors, :win}  -> 1 + 6
        end
    end
    )
    # |> IO.inspect
    |> Enum.sum
  end

  def p1_fast(input) do
    Stream.map(input, fn g ->
        case g do
          "A X\n" -> 1 + 3
          "A Y\n" -> 2 + 6
          "A Z\n" -> 3 + 0
                 
          "B X\n" -> 1 + 0
          "B Y\n" -> 2 + 3
          "B Z\n" -> 3 + 6
                 
          "C X\n" -> 1 + 6
          "C Y\n" -> 2 + 0
          "C Z\n" -> 3 + 3
        end
      end
    )
    # |> IO.inspect
    |> Enum.sum
  end

  def p2_fast(input) do
    Stream.map(input, fn g ->
        case g do
          "A X\n" -> 3 + 0
          "A Y\n" -> 1 + 3
          "A Z\n" -> 2 + 6

          "B X\n" -> 1 + 0
          "B Y\n" -> 2 + 3
          "B Z\n" -> 3 + 6

          "C X\n" -> 2 + 0
          "C Y\n" -> 3 + 3
          "C Z\n" -> 1 + 6
        end
      end
    )
    # |> IO.inspect
    |> Enum.sum
  end
end



{t, :ok} = :timer.tc(fn ->
  {t_io, lines} = :timer.tc(fn ->
      IO.stream(:stdio, :line)
      |> Enum.to_list
    end
  )

  {t_p1, p1} = :timer.tc(&Solve.p1/1, [lines])
  {t_p2, p2} = :timer.tc(&Solve.p2/1, [lines])
  {t_p1_fast, p1_fast} = :timer.tc(&Solve.p1_fast/1, [lines])
  {t_p2_fast, p2_fast} = :timer.tc(&Solve.p2_fast/1, [lines])

  IO.puts("io: #{t_io/1000}ms")

  IO.puts("p1: #{p1} (#{t_p1/1000}ms)")
  IO.puts("p1_fast: #{p1_fast} (#{t_p1_fast/1000}ms)")

  IO.puts("p2: #{p2} (#{t_p2/1000}ms)")
  IO.puts("p2_fast: #{p2_fast} (#{t_p2_fast/1000}ms)")
  :ok
  end
)
IO.puts("total: #{t/1000}ms")
