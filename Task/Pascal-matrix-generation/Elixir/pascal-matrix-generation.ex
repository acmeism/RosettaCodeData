defmodule Pascal do
  defp ij(n), do: for i <- 1..n, j <- 1..n, do: {i,j}

  def upper_triangle(n) do
    Enum.reduce(ij(n), Map.new, fn {i,j},acc ->
      val = cond do
              i==1 -> 1
              j<i  -> 0
              true -> Map.get(acc, {i-1, j-1}) + Map.get(acc, {i, j-1})
            end
      Map.put(acc, {i,j}, val)
    end) |> print(1..n)
  end

  def lower_triangle(n) do
    Enum.reduce(ij(n), Map.new, fn {i,j},acc ->
      val = cond do
              j==1 -> 1
              i<j  -> 0
              true -> Map.get(acc, {i-1, j-1}) + Map.get(acc, {i-1, j})
            end
      Map.put(acc, {i,j}, val)
    end) |> print(1..n)
  end

  def symmetic_triangle(n) do
    Enum.reduce(ij(n), Map.new, fn {i,j},acc ->
      val = if i==1 or j==1, do: 1,
                           else: Map.get(acc, {i-1, j}) + Map.get(acc, {i, j-1})
      Map.put(acc, {i,j}, val)
    end) |> print(1..n)
  end

  def print(matrix, range) do
    Enum.each(range, fn i ->
      Enum.map(range, fn j -> Map.get(matrix, {i,j}) end) |> IO.inspect
    end)
  end
end

IO.puts "Pascal upper-triangular matrix:"
Pascal.upper_triangle(5)
IO.puts "Pascal lower-triangular matrix:"
Pascal.lower_triangle(5)
IO.puts "Pascal symmetric matrix:"
Pascal.symmetic_triangle(5)
