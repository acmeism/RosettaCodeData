defmodule LCS do
  def lcs_length(s,t), do: lcs_length(s,t,Map.new) |> elem(0)

  defp lcs_length([],t,cache), do: {0,Map.put(cache,{[],t},0)}
  defp lcs_length(s,[],cache), do: {0,Map.put(cache,{s,[]},0)}
  defp lcs_length([h|st]=s,[h|tt]=t,cache) do
    {l,c} = lcs_length(st,tt,cache)
    {l+1,Map.put(c,{s,t},l+1)}
  end
  defp lcs_length([_sh|st]=s,[_th|tt]=t,cache) do
    if Map.has_key?(cache,{s,t}) do
      {Map.get(cache,{s,t}),cache}
    else
      {l1,c1} = lcs_length(s,tt,cache)
      {l2,c2} = lcs_length(st,t,c1)
      l = max(l1,l2)
      {l,Map.put(c2,{s,t},l)}
    end
  end

  def lcs(s,t) do
    {s,t} = {to_charlist(s),to_charlist(t)}
    {_,c} = lcs_length(s,t,Map.new)
    lcs(s,t,c,[]) |> to_string
  end

  defp lcs([],_,_,acc), do: Enum.reverse(acc)
  defp lcs(_,[],_,acc), do: Enum.reverse(acc)
  defp lcs([h|st],[h|tt],cache,acc), do: lcs(st,tt,cache,[h|acc])
  defp lcs([_sh|st]=s,[_th|tt]=t,cache,acc) do
    if Map.get(cache,{s,tt}) > Map.get(cache,{st,t}) do
      lcs(s,tt,cache,acc)
    else
      lcs(st,t,cache,acc)
    end
  end
end

IO.puts LCS.lcs("thisisatest","testing123testing")
IO.puts LCS.lcs("1234","1224533324")
