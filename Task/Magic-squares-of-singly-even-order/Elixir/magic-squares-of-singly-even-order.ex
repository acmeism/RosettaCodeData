defmodule Magic_square do
  @lux  %{ L: [4, 1, 2, 3], U: [1, 4, 2, 3], X: [1, 4, 3, 2] }

  def singly_even(n) when rem(n-2,4)!=0, do: raise ArgumentError, "must be even, but not divisible by 4."
  def singly_even(2), do: raise ArgumentError, "2x2 magic square not possible."
  def singly_even(n) do
    n2 = div(n, 2)
    oms = odd_magic_square(n2)
    mat = make_lux_matrix(n2)
    square = synthesis(n2, oms, mat)
    IO.puts to_string(n, square)
    square
  end

  defp odd_magic_square(m) do       # zero beginning, it is 4 multiples.
    for i <- 0..m-1, j <- 0..m-1, into: %{},
        do: {{i,j}, (m*(rem(i+j+1+div(m,2),m)) + rem(i+2*j-5+2*m, m)) * 4}
  end

  defp make_lux_matrix(m) do
    center = div(m, 2)
    lux = List.duplicate(:L, center+1) ++ [:U] ++ List.duplicate(:X, m-center-2)
    (for {x,i} <- Enum.with_index(lux), j <- 0..m-1, into: %{}, do: {{i,j}, x})
    |> Map.put({center,   center}, :U)
    |> Map.put({center+1, center}, :L)
  end

  defp synthesis(m, oms, mat) do
    range = 0..m-1
    Enum.reduce(range, [], fn i,acc ->
      {row0, row1} = Enum.reduce(range, {[],[]}, fn j,{r0,r1} ->
                       x = oms[{i,j}]
                       [lux0, lux1, lux2, lux3] = @lux[mat[{i,j}]]
                       {[x+lux0, x+lux1 | r0], [x+lux2, x+lux3 | r1]}
                     end)
      [row0, row1 | acc]
    end)
  end

  defp to_string(n, square) do
    format = String.duplicate("~#{length(to_char_list(n*n))}w ", n) <> "\n"
    Enum.map_join(square, fn row ->
      :io_lib.format(format, row)
    end)
  end
end

Magic_square.singly_even(6)
