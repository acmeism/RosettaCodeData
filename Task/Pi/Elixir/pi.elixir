defmodule Pi do
  def calc, do: calc(1,0,1,1,3,3,0)

  defp calc(q,r,t,k,n,l,c) when c==50 do
    IO.write "\n"
    calc(q,r,t,k,n,l,0)
  end
  defp calc(q,r,t,k,n,l,c) when (4*q + r - t) < n*t do
    IO.write n
    calc(q*10, 10*(r-n*t), t, k, div(10*(3*q+r), t) - 10*n, l, c+1)
  end
  defp calc(q,r,t,k,_n,l,c) do
    calc(q*k, (2*q+r)*l, t*l, k+1, div(q*7*k+2+r*l, t*l), l+2, c)
  end
end

Pi.calc
