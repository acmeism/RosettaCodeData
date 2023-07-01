defmodule Brace_expansion do
  def getitem(s), do: getitem(String.codepoints(s), 0, [""])

  defp getitem([], _, out), do: {out,[]}
  defp getitem([c|_]=s, depth, out) when depth>0 and (c == "," or c == "}"), do: {out,s}
  defp getitem([c|t], depth, out) do
    x = getgroup(t, depth+1, [], false)
    if (c == "{") and x do
      {y, z} = x
      out2 = for a <- out, b <- y, do: a<>b
      getitem(z, depth, out2)
    else
      if c == "\\" and length(t) > 0 do
        c2 = c <> hd(t)
        getitem(tl(t), depth, Enum.map(out, fn a -> a <> c2 end))
      else
        getitem(t, depth, Enum.map(out, fn a -> a <> c end))
      end
    end
  end

  defp getgroup([], _, _, _), do: nil
  defp getgroup(s, depth, out, comma) do
    {g, s2} = getitem(s, depth, [""])
    if s2 == [] do
      nil
    else
      out2 = out ++ g
      case hd(s2) do
        "}" -> if comma, do: {out2, tl(s2)},
                       else: {Enum.map(out2, &"{#{&1}}"), tl(s2)}
        "," -> getgroup(tl(s2), depth, out2, true)
        _   -> getgroup(s2, depth, out2, comma)
      end
    end
  end
end

test_cases = ~S"""
~/{Downloads,Pictures}/*.{jpg,gif,png}
It{{em,alic}iz,erat}e{d,}, please.
{,{,gotta have{ ,\, again\, }}more }cowbell!
{}} some }{,{\\{ edge, edge} \,}{ cases, {here} \\\\\}
""" |> String.split("\n", trim: true)

Enum.each(test_cases, fn s ->
  IO.puts s
  Brace_expansion.getitem(s)
  |> elem(0)
  |> Enum.each(fn str -> IO.puts "\t#{str}" end)
  IO.puts ""
end)
