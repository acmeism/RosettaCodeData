defmodule Queue do
  def empty?([]), do: true
  def empty?(_), do: false

  def pop([h|t]), do: {h,t}

  def push(q,t), do: q ++ [t]

  def front([h|_]), do: h
end
