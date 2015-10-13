defmodule Hamming do
  def generater do
    queues = [{2, queue}, {3, queue}, {5, queue}]
    Stream.unfold({1, queues}, fn {n, q} -> next(n, q) end)
  end

  defp next(n, queues) do
    queues = Enum.map(queues, fn {m, queue} -> {m, push(queue, m*n)} end)
    min    = Enum.map(queues, fn {_, queue} -> top(queue) end) |> Enum.min
    queues = Enum.map(queues, fn {m, queue} ->
               {m, (if min==top(queue), do: erase_top(queue), else: queue)}
             end)
    {n, {min, queues}}
  end

  defp queue, do: {[], []}

  defp push({input, output}, term), do: {[term | input], output}

  defp top({input, []}), do: List.last(input)
  defp top({_, [h|_]}), do: h

  defp erase_top({input, []}), do: erase_top({[], Enum.reverse(input)})
  defp erase_top({input, [_|t]}), do: {input, t}
end

IO.puts "first twenty Hamming numbers:"
IO.inspect Hamming.generater |> Enum.take(20)
IO.puts "1691st Hamming number:"
IO.puts Hamming.generater |> Enum.take(1691) |> List.last
IO.puts "one millionth Hamming number:"
IO.puts Hamming.generater |> Enum.take(1_000_000) |> List.last
