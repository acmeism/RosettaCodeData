defmodule Sum do
  def to(val) do
    generate
    |> Enum.map(&{eval(&1), &1})
    |> Enum.filter(fn {v, _s} -> v==val end)
    |> Enum.each(&IO.inspect &1)
  end

  def max_solve do
    generate
    |> Enum.group_by(&eval &1)
    |> Enum.filter_map(fn {k,_} -> k>=0 end, fn {k,v} -> {length(v),k} end)
    |> Enum.max
    |> fn {len,sum} -> IO.puts "sum of #{sum} has the maximum number of solutions : #{len}" end.()
  end

  def min_solve do
    solve = generate |> Enum.group_by(&eval &1)
    Stream.iterate(1, &(&1+1))
    |> Enum.find(fn n -> solve[n]==nil end)
    |> fn sum -> IO.puts "lowest positive sum that can't be expressed : #{sum}" end.()
  end

  def  highest_sums(n\\10) do
    IO.puts "highest sums :"
    generate
    |> Enum.map(&eval &1)
    |> Enum.uniq
    |> Enum.sort_by(fn sum -> -sum end)
    |> Enum.take(n)
    |> IO.inspect
  end

  defp generate do
    x = ["+", "-", ""]
    for a <- ["-", ""], b <- x, c <- x, d <- x, e <- x, f <- x, g <- x, h <- x, i <- x,
        do: "#{a}1#{b}2#{c}3#{d}4#{e}5#{f}6#{g}7#{h}8#{i}9"
  end

  defp eval(str), do: Code.eval_string(str) |> elem(0)
end

Sum.to(100)
Sum.max_solve
Sum.min_solve
Sum.highest_sums
