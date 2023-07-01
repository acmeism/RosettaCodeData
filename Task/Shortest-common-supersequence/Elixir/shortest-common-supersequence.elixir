defmodule SCS do
  def scs(u, v) do
    lcs = LCS.lcs(u, v) |> to_charlist
    scs(to_charlist(u), to_charlist(v), lcs, []) |> to_string
  end

  defp scs(u, v, [], res), do: Enum.reverse(res) ++ u ++ v
  defp scs([h|ut], [h|vt], [h|lt], res),      do: scs(ut, vt, lt, [h|res])
  defp scs([h|_]=u, [vh|vt], [h|_]=lcs, res), do: scs(u, vt, lcs, [vh|res])
  defp scs([uh|ut], v, lcs, res),             do: scs(ut, v, lcs, [uh|res])
end

u = "abcbdab"
v = "bdcaba"
IO.puts "SCS(#{u}, #{v}) = #{SCS.scs(u, v)}"
