defmodule LCS do
  def longest_common_substring(a,b) do
    alist = to_charlist(a) |> Enum.with_index
    blist = to_charlist(b) |> Enum.with_index
    lengths = for i <- 0..length(alist)-1, j <- 0..length(blist), into: %{}, do: {{i,j},0}
    Enum.reduce(alist, {lengths,0,""}, fn {x,i},acc ->
      Enum.reduce(blist, acc, fn {y,j},{map,gleng,lcs} ->
        if x==y do
          len = if i==0 or j==0, do: 1, else: map[{i-1,j-1}]+1
          map = %{map | {i,j} => len}
          if len > gleng, do: {map, len, String.slice(a, i - len + 1, len)},
                        else: {map, gleng, lcs}
        else
          {map, gleng, lcs}
        end
      end)
    end)
    |> elem(2)
  end
end

IO.puts LCS.longest_common_substring("thisisatest", "testing123testing")
