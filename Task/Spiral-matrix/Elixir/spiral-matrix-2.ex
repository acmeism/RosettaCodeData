defmodule RC do
  def spiral_matrix(n) do
    wide = String.length(to_string(n*n-1))
    fmt = String.duplicate("~#{wide}w ", n) <> "~n"
    right(n,n-1,0,[]) |> Enum.reverse |> Enum.with_index |> Enum.sort |> Enum.chunk(n) |>
      Enum.each(fn row ->
        :io.format fmt, (for {_,i} <- row, do: i)
      end)
  end

  def right(n, side, i, coordinates) do
    down(n, side, i, Enum.reduce(0..side, coordinates, fn j,acc -> [{i, i+j} | acc] end))
  end

  def down(_, 0, _, coordinates), do: coordinates
  def down(n, side, i, coordinates) do
    left(n, side-1, i, Enum.reduce(1..side, coordinates, fn j,acc -> [{i+j, n-1-i} | acc] end))
  end

  def left(n, side, i, coordinates) do
    up(n, side, i, Enum.reduce(side..0, coordinates, fn j,acc -> [{n-1-i, i+j} | acc] end))
  end

  def up(_, 0, _, coordinates), do: coordinates
  def up(n, side, i, coordinates) do
    right(n, side-1, i+1, Enum.reduce(side..1, coordinates, fn j,acc -> [{i+j, i} | acc] end))
  end
end

RC.spiral_matrix(5)
