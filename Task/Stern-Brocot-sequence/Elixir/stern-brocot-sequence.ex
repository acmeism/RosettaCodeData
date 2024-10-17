defmodule SternBrocot do
  def sequence do
    Stream.unfold({0,{1,1}}, fn {i,acc} ->
      a = elem(acc, i)
      b = elem(acc, i+1)
      {a, {i+1, Tuple.append(acc, a+b) |> Tuple.append(b)}}
    end)
  end

  def task do
    IO.write "First fifteen members of the sequence:\n  "
    IO.inspect Enum.take(sequence, 15)
    Enum.each(Enum.concat(1..10, [100]), fn n ->
      i = Enum.find_index(sequence, &(&1==n)) + 1
      IO.puts "#{n} first appears at #{i}"
    end)
    Enum.take(sequence, 1000)
    |> Enum.chunk(2,1)
    |> Enum.all?(fn [a,b] -> gcd(a,b) == 1 end)
    |> if(do: "All GCD's are 1", else: "Whoops, not all GCD's are 1!")
    |> IO.puts
  end

  defp gcd(a,0), do: abs(a)
  defp gcd(a,b), do: gcd(b, rem(a,b))
end

SternBrocot.task
