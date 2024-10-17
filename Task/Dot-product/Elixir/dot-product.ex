defmodule Vector do
  def dot_product(a,b) when length(a)==length(b), do: dot_product(a,b,0)
  def dot_product(_,_) do
    raise ArgumentError, message: "Vectors must have the same length."
  end

  defp dot_product([],[],product), do: product
  defp dot_product([h1|t1], [h2|t2], product), do: dot_product(t1, t2, product+h1*h2)
end

IO.puts Vector.dot_product([1,3,-5],[4,-2,-1])
