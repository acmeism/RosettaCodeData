defmodule Gray_code do
  use Bitwise
  def encode(n), do: bxor(n, bsr(n,1))

  def decode(g), do: decode(g,0)

  def decode(0,n), do: n
  def decode(g,n), do: decode(bsr(g,1), bxor(g,n))
end

Enum.each(0..31, fn(n) ->
  g = Gray_code.encode(n)
  d = Gray_code.decode(g)
  :io.fwrite("~2B : ~5.2.0B : ~5.2.0B : ~5.2.0B : ~2B~n", [n, n, g, d, d])
end)
