defmodule Linear_combination do
  def display(coeff) do
    Enum.with_index(coeff)
    |> Enum.map_join(fn {n,i} ->
         {m,s} = if n<0, do: {-n,"-"}, else: {n,"+"}
         case {m,i} do
           {0,_} -> ""
           {1,i} -> "#{s}e(#{i+1})"
           {n,i} -> "#{s}#{n}*e(#{i+1})"
         end
       end)
    |> String.trim_leading("+")
    |> case do
         ""  -> IO.puts "0"
         str -> IO.puts str
       end
  end
end

coeffs =
  [ [1, 2, 3],
    [0, 1, 2, 3],
    [1, 0, 3, 4],
    [1, 2, 0],
    [0, 0, 0],
    [0],
    [1, 1, 1],
    [-1, -1, -1],
    [-1, -2, 0, -3],
    [-1]
  ]
Enum.each(coeffs, &Linear_combination.display(&1))
