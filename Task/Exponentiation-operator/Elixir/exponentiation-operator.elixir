defmodule My do
  def exp(x,y) when is_integer(x) and is_integer(y) and y>=0 do
    IO.write("int>   ")         # debug test
    exp_int(x,y)
  end
  def exp(x,y) when is_integer(y) do
    IO.write("float> ")         # debug test
    exp_float(x,y)
  end
  def exp(x,y), do: (IO.write("       "); :math.pow(x,y))

  defp exp_int(_,0), do: 1
  defp exp_int(x,y), do: Enum.reduce(1..y, 1, fn _,acc -> x * acc end)

  defp exp_float(_,y) when y==0, do: 1.0
  defp exp_float(x,y) when y<0, do: 1/exp_float(x,-y)
  defp exp_float(x,y), do: Enum.reduce(1..y, 1, fn _,acc -> x * acc end)
end

list = [{2,0}, {2,3}, {2,-2},
        {2.0,0}, {2.0,3}, {2.0,-2},
        {0.5,0}, {0.5,3}, {0.5,-2},
        {-2,2}, {-2,3}, {-2.0,2}, {-2.0,3},
        ]
IO.puts "                    ___My.exp___  __:math.pow_"
Enum.each(list, fn {x,y} ->
  sxy = "#{x} ** #{y}"
  sexp = inspect My.exp(x,y)
  spow = inspect :math.pow(x,y)         # For the comparison
  :io.fwrite("~10s = ~12s, ~12s~n", [sxy, sexp, spow])
end)
