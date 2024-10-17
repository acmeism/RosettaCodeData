defmodule Equilibrium do
  def index(list) do
    last = length(list)
    Enum.filter(0..last-1, fn i ->
      Enum.sum(Enum.slice(list, 0, i)) == Enum.sum(Enum.slice(list, i+1..last))
    end)
  end
end
