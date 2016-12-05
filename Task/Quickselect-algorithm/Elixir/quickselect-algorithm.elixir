defmodule Quick do
  def select(k, [x|xs]) do
    {ys, zs} = Enum.partition(xs, fn e -> e < x end)
    l = length(ys)
    cond do
      k < l -> select(k, ys)
      k > l -> select(k - l - 1, zs)
      true  -> x
    end
  end

  def test do
    v = [9, 8, 7, 6, 5, 0, 1, 2, 3, 4]
    Enum.map(0..length(v)-1, fn i -> select(i,v) end)
    |> IO.inspect
  end
end

Quick.test
