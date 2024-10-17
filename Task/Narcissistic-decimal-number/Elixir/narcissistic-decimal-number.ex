defmodule RC do
  def narcissistic(m) do
    Enum.reduce(1..10, [0], fn digits,acc ->
      digitPowers = List.to_tuple(for i <- 0..9, do: power(i, digits))
      Enum.reduce(power(10, digits-1) .. power(10, digits)-1, acc, fn n,result ->
        sum = divsum(n, digitPowers, 0)
        if n == sum do
          if length(result) == m-1, do: throw Enum.reverse(result, [n])
          [n | result]
        else
          result
        end
      end)
    end)
  end

  defp divsum(0, _, sum), do: sum
  defp divsum(n, digitPowers, sum) do
    divsum(div(n,10), digitPowers, sum+elem(digitPowers,rem(n,10)))
  end

  defp power(n, m), do: power(n, m, 1)

  defp power(_, 0, pow), do: pow
  defp power(n, m, pow), do: power(n, m-1, pow*n)
end

try do
  RC.narcissistic(25)
catch
  x -> IO.inspect x
end
