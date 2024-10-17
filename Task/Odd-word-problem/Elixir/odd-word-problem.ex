defmodule Odd_word do
  def handle(s, false, i, o) when ((s >= "a" and s <= "z") or (s >= "A" and s <= "Z")) do
    o.(s)
    handle(i.(), false, i, o)
  end
  def handle(s, t, i, o) when ((s >= "a" and s <= "z") or (s >= "A" and s <= "Z")) do
    d = handle(i.(), :rec, i, o)
    o.(s)
    if t == true, do: handle(d, t, i, o), else: d
  end
  def handle(s, :rec, _, _), do: s
  def handle(?., _, _, o), do: o.(?.); :done
  def handle(:eof, _, _, _), do: :done
  def handle(s, t, i, o) do
    o.(s)
    handle(i.(), not t, i, o)
  end

  def main do
    i = fn() -> IO.getn("") end
    o = fn(s) -> IO.write(s) end
    handle(i.(), false, i, o)
  end
end

Odd_word.main
