defmodule Game24 do
  @expressions [ ["((", "", ")", "", ")", ""],
                 ["(", "(", "", "", "))", ""],
                 ["(", "", ")", "(", "", ")"],
                 ["", "((", "", "", ")", ")"],
                 ["", "(", "", "(", "", "))"] ]

  def solve(digits) do
    dig_perm = permute(digits) |> Enum.uniq
    operators = perm_rep(~w[+ - * /], 3)
    for dig <- dig_perm, ope <- operators, expr <- @expressions,
        check?(str = make_expr(dig, ope, expr)),
        do: str
  end

  defp check?(str) do
    try do
      {val, _} = Code.eval_string(str)
      val == 24
    rescue
      ArithmeticError -> false      # division by zero
    end
  end

  defp permute([]), do: [[]]
  defp permute(list) do
    for x <- list, y <- permute(list -- [x]), do: [x|y]
  end

  defp perm_rep([], _), do: [[]]
  defp perm_rep(_,  0), do: [[]]
  defp perm_rep(list, i) do
    for x <- list, y <- perm_rep(list, i-1), do: [x|y]
  end

  defp make_expr([a,b,c,d], [x,y,z], [e0,e1,e2,e3,e4,e5]) do
    e0 <> a <> x <> e1 <> b <> e2 <> y <> e3 <> c <> e4 <> z <> d <> e5
  end
end

case Game24.solve(System.argv) do
  [] -> IO.puts "no solutions"
  solutions ->
    IO.puts "found #{length(solutions)} solutions, including #{hd(solutions)}"
    IO.inspect Enum.sort(solutions)
end
