defmodule RC do
  def choose(n,k) when is_integer(n) and is_integer(k) and n>=0 and k>=0 and n>=k do
    if k==0, do: 1, else: choose(n,k,1,1)
  end

  def choose(n,k,k,acc), do: div(acc * (n-k+1), k)
  def choose(n,k,i,acc), do: choose(n, k, i+1, div(acc * (n-i+1), i))
end

IO.inspect RC.choose(5,3)
IO.inspect RC.choose(60,30)
