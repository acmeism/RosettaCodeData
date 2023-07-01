defmodule RC do
  def count_triples(limit), do: count_triples(limit,3,4,5)

  defp count_triples(limit, a, b, c) when limit<(a+b+c), do: {0,0}
  defp count_triples(limit, a, b, c) do
    {p1, t1} = count_triples(limit, a-2*b+2*c, 2*a-b+2*c, 2*a-2*b+3*c)
    {p2, t2} = count_triples(limit, a+2*b+2*c, 2*a+b+2*c, 2*a+2*b+3*c)
    {p3, t3} = count_triples(limit,-a+2*b+2*c,-2*a+b+2*c,-2*a+2*b+3*c)
    {1+p1+p2+p3, div(limit, a+b+c)+t1+t2+t3}
  end
end

list = for n <- 1..8, do: Enum.reduce(1..n, 1, fn(_,acc)->10*acc end)
Enum.each(list, fn n -> IO.inspect {n, RC.count_triples(n)} end)
