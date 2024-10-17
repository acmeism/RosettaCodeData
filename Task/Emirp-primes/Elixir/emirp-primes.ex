defmodule Emirp do
  defp prime?(2), do: true
  defp prime?(n) when n<2 or rem(n,2)==0, do: false
  defp prime?(n), do: prime?(n,3)

  defp prime?(n,k) when n<k*k, do: true
  defp prime?(n,k) when rem(n,k)==0, do: false
  defp prime?(n,k), do: prime?(n,k+2)

  def emirp?(n) do
    if prime?(n) do
      reverse = to_string(n) |> String.reverse |> String.to_integer
      n != reverse and prime?(reverse)
    end
  end

  def task do
    emirps = Stream.iterate(1, &(&1+1)) |> Stream.filter(&emirp?/1)
    first = Enum.take(emirps,20) |> Enum.join(" ")
    IO.puts "First 20 emirps: #{first}"
    between = Enum.reduce_while(emirps, [], fn x,acc ->
      cond do
        x < 7700        -> {:cont, acc}
        x in 7700..8000 -> {:cont, [x | acc]}
        true            -> {:halt, Enum.reverse(acc)}
      end
    end) |> Enum.join(" ")
    IO.puts "Emirps between 7,700 and 8,000: #{between}"
    IO.puts "10,000th emirp: #{Enum.at(emirps, 9999)}"
  end
end

Emirp.task
