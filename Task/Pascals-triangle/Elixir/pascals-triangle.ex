defmodule Pascal do
  def triangle(n), do: triangle(n,[1])

  def triangle(0,list), do: list
  def triangle(n,list) do
    IO.inspect list
    new_list = Enum.zip([0]++list, list++[0]) |> Enum.map(fn {a,b} -> a+b end)
    triangle(n-1,new_list)
  end
end

Pascal.triangle(8)
