defmodule Ulam do
  defp cell(n, x, y, start) do
    y = y - div(n, 2)
    x = x - div(n - 1, 2)
    l = 2 * max(abs(x), abs(y))
    d = if y >= x, do: l*3 + x + y, else: l - x - y
    (l - 1)*(l - 1) + d + start - 1
  end

  def show_spiral(n, symbol\\nil, start\\1) do
    IO.puts "\nN : #{n}"
    if symbol==nil, do: format = "~#{length(to_char_list(start + n*n - 1))}s "
    prime = prime(n*n + start)
    Enum.each(0..n-1, fn y ->
      Enum.each(0..n-1, fn x ->
        i = cell(n, x, y, start)
        if symbol do
          IO.write if i in prime, do: Enum.at(symbol,0), else: Enum.at(symbol,1)
        else
          :io.fwrite format, [if i in prime do to_char_list(i) else "" end]
        end
      end)
      IO.puts ""
    end)
  end

  defp prime(num), do: prime(Enum.to_list(2..num), [])
  defp prime([], p), do: Enum.reverse(p)
  defp prime([h|t], p), do: prime((for i <- t, rem(i,h)>0, do: i), [h|p])
end

Ulam.show_spiral(9)
Ulam.show_spiral(25)
Ulam.show_spiral(25, ["#"," "])
