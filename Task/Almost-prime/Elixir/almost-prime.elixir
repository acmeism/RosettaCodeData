defmodule Factors do
  def factors(n), do: factors(n,2,[])

  defp factors(1,_,acc), do: acc
  defp factors(n,k,acc) when rem(n,k)==0, do: factors(div(n,k),k,[k|acc])
  defp factors(n,k,acc)                 , do: factors(n,k+1,acc)

  def kfactors(n,k), do: kfactors(n,k,1,1,[])

  defp kfactors(_tn,tk,_n,k,_acc) when k == tk+1, do: IO.puts "done! "
  defp kfactors(tn,tk,_n,k,acc) when length(acc) == tn do
    IO.puts "K: #{k} #{inspect acc}"
    kfactors(tn,tk,2,k+1,[])
  end
  defp kfactors(tn,tk,n,k,acc) do
    case length(factors(n)) do
      ^k -> kfactors(tn,tk,n+1,k,acc++[n])
      _  -> kfactors(tn,tk,n+1,k,acc)
    end
  end
end

Factors.kfactors(10,5)
