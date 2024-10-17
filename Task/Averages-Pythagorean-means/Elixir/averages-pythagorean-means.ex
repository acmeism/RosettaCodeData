defmodule Means do
  def arithmetic(list) do
    Enum.sum(list) / length(list)
  end
  def geometric(list) do
    :math.pow(Enum.reduce(list, &(*/2)), 1 / length(list))
  end
  def harmonic(list) do
    1 / arithmetic(Enum.map(list, &(1 / &1)))
  end
end

list = Enum.to_list(1..10)
IO.puts "Arithmetic mean: #{am = Means.arithmetic(list)}"
IO.puts "Geometric mean:  #{gm = Means.geometric(list)}"
IO.puts "Harmonic mean:   #{hm = Means.harmonic(list)}"
IO.puts "(#{am} >= #{gm} >= #{hm}) is #{am >= gm and gm >= hm}"
