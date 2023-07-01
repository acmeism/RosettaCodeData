defmodule Coins do
  def find(coins,lim) do
    vals = Map.new(0..lim,&{&1,0}) |> Map.put(0,1)
    count(coins,lim,vals)
      |> Map.values
      |> Enum.max
      |> IO.inspect
  end

  defp count([],_,vals), do: vals
  defp count([coin|coins],lim,vals) do
    count(coins,lim,ways(coin,coin,lim,vals))
  end

  defp ways(num,_coin,lim,vals) when num > lim, do: vals
  defp ways(num, coin,lim,vals) do
    ways(num+1,coin,lim,ad(coin,num,vals))
  end

  defp ad(a,b,c), do: Map.put(c,b,c[b]+c[b-a])
end

Coins.find([1,5,10,25],100)
Coins.find([1,5,10,25,50,100],100_000)
