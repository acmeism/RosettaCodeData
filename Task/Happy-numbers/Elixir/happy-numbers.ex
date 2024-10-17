defmodule Happy do
  def task(num) do
    Process.put({:happy, 1}, true)
    Stream.iterate(1, &(&1+1))
    |> Stream.filter(fn n -> happy?(n) end)
    |> Enum.take(num)
  end

  defp happy?(n) do
    sum = square_sum(n, 0)
    val = Process.get({:happy, sum})
    if val == nil do
      Process.put({:happy, sum}, false)
      val = happy?(sum)
      Process.put({:happy, sum}, val)
    end
    val
  end

  defp square_sum(0, sum), do: sum
  defp square_sum(n, sum) do
    r = rem(n, 10)
    square_sum(div(n, 10), sum + r*r)
  end
end

IO.inspect Happy.task(8)
