defmodule Josephus do
  def find(n,k) do
    find(Enum.to_list(0..n-1),0..k-2,k..n)
  end

  def find([_|[r|_]],_,_..d) when d < 3 do
    IO.inspect r
  end

  def find(arr,a..c,b..d) when length(arr) >= 3 do
    find(Enum.slice(arr,b..d) ++ Enum.slice(arr,a..c),a..c,b..d-1)
  end
end

Josephus.find(41,3)
