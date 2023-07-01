defmodule Ternary do
  def to_string(t), do: ( for x <- t, do: to_char(x) ) |> List.to_string

  def from_string(s), do: ( for x <- to_char_list(s), do: from_char(x) )

  defp to_char(-1), do: ?-
  defp to_char(0), do: ?0
  defp to_char(1), do: ?+

  defp from_char(?-), do: -1
  defp from_char(?0), do: 0
  defp from_char(?+), do: 1

  def to_ternary(n) when n > 0, do: to_ternary(n,[])
  def to_ternary(n), do: neg(to_ternary(-n))

  defp to_ternary(0,acc), do: acc
  defp to_ternary(n,acc) when rem(n, 3) == 0, do: to_ternary(div(n, 3), [0|acc])
  defp to_ternary(n,acc) when rem(n, 3) == 1, do: to_ternary(div(n, 3), [1|acc])
  defp to_ternary(n,acc), do: to_ternary(div((n+1), 3), [-1|acc])

  def from_ternary(t), do: from_ternary(t,0)

  defp from_ternary([],acc), do: acc
  defp from_ternary([h|t],acc), do: from_ternary(t, acc*3 + h)

  def mul(a,b), do: mul(b,a,[])

  defp mul(_,[],acc), do: acc
  defp mul(b,[a|as],acc) do
    bp = case a do
           -1 -> neg(b)
            0 -> [0]
            1 -> b
         end
    a = add(bp, acc ++ [0])
    mul(b,as,a)
  end

  defp neg(t), do: ( for h <- t, do: -h )

  def sub(a,b), do: add(a,neg(b))

  def add(a,b) when length(a) < length(b),
    do: add(List.duplicate(0, length(b)-length(a)) ++ a, b)
  def add(a,b) when length(a) > length(b), do: add(b,a)
  def add(a,b), do: add(Enum.reverse(a), Enum.reverse(b), 0, [])

  defp add([],[],0,acc), do: acc
  defp add([],[],c,acc), do: [c|acc]
  defp add([a|as],[b|bs],c,acc) do
    [c1,d] = add_util(a+b+c)
    add(as,bs,c1,[d|acc])
  end

  defp add_util(-3), do: [-1,0]
  defp add_util(-2), do: [-1,1]
  defp add_util(-1), do: [0,-1]
  defp add_util(3), do: [1,0]
  defp add_util(2), do: [1,-1]
  defp add_util(1), do: [0,1]
  defp add_util(0), do: [0,0]
end

as = "+-0++0+"; at = Ternary.from_string(as); a = Ternary.from_ternary(at)
b = -436; bt = Ternary.to_ternary(b); bs = Ternary.to_string(bt)
cs = "+-++-"; ct = Ternary.from_string(cs); c = Ternary.from_ternary(ct)
rt = Ternary.mul(at,Ternary.sub(bt,ct))
r = Ternary.from_ternary(rt)
rs = Ternary.to_string(rt)
IO.puts "a = #{as} -> #{a}"
IO.puts "b = #{bs} -> #{b}"
IO.puts "c = #{cs} -> #{c}"
IO.puts "a x (b - c) = #{rs} -> #{r}"
