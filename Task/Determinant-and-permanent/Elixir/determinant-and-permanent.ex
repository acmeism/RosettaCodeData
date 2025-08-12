defmodule MatrixArithmetic do
  def minor(a, x, y) do
    length = length(a) - 1
    for i <- 0..(length - 1), into: [] do
      for j <- 0..(length - 1), into: [] do
        cond do
          i < x && j < y -> Enum.at(Enum.at(a, i), j)
          i >= x && j < y -> Enum.at(Enum.at(a, i + 1), j)
          i < x && j >= y -> Enum.at(Enum.at(a, i), j + 1)
          true -> Enum.at(Enum.at(a, i + 1), j + 1)
        end
      end
    end
  end

  def det(a) do
    if length(a) == 1 do
      Enum.at(Enum.at(a, 0), 0)
    else
      Enum.reduce(0..(length(a) - 1), 0, fn i, sum ->
        sign = if rem(i, 2) == 0, do: 1, else: -1
        sum + sign * Enum.at(Enum.at(a, 0), i) * det(minor(a, 0, i))
      end)
    end
  end

  def perm(a) do
    if length(a) == 1 do
      Enum.at(Enum.at(a, 0), 0)
    else
      Enum.reduce(0..(length(a) - 1), 0, fn i, sum ->
        sum + Enum.at(Enum.at(a, 0), i) * perm(minor(a, 0, i))
      end)
    end
  end

  def main do
    # Using the provided test matrix
    m = [
      [0, 1, 2, 3, 4],
      [5, 6, 7, 8, 9],
      [10, 11, 12, 13, 14],
      [15, 16, 17, 18, 19],
      [20, 21, 22, 23, 24]
    ]

    IO.puts("Determinant: #{det(m)}")
    IO.puts("Permanent: #{perm(m)}")
  end
end

MatrixArithmetic.main()
