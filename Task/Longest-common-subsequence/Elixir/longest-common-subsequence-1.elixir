defmodule LCS do
  def lcs(a, b) do
    lcs(to_charlist(a), to_charlist(b), []) |> to_string
  end

  defp lcs([h|at], [h|bt], res), do: lcs(at, bt, [h|res])
  defp lcs([_|at]=a, [_|bt]=b, res) do
    Enum.max_by([lcs(a, bt, res), lcs(at, b, res)], &length/1)
  end
  defp lcs(_, _, res), do: res |> Enum.reverse
end

IO.puts LCS.lcs("thisisatest", "testing123testing")
IO.puts LCS.lcs('1234','1224533324')
