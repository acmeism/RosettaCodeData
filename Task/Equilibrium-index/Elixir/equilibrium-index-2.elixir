defmodule Equilibrium do
  def index(list), do: index(list,0,0,Enum.sum(list),[])

  defp index([],_,_,_,acc), do: Enum.reverse(acc)
  defp index([h|t],i,left,right,acc) when left==right-h, do: index(t,i+1,left+h,right-h,[i|acc])
  defp index([h|t],i,left,right,acc)                   , do: index(t,i+1,left+h,right-h,acc)
end
