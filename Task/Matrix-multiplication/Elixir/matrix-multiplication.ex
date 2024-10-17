  def mult(m1, m2) do
    Enum.map m1, fn (x) -> Enum.map t(m2), fn (y) -> Enum.zip(x, y)
        |> Enum.map(fn {x, y} -> x * y end)
        |> Enum.sum
      end
    end
  end

  def t(m) do # transpose
    List.zip(m) |> Enum.map(&Tuple.to_list(&1))
  end
