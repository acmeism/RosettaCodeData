defmodule RC do
  def gcd(a,0), do: abs(a)
  def gcd(a,b), do: gcd(b, rem(a,b))

  def lcm(a,b), do: div(abs(a*b), gcd(a,b))
end

IO.puts RC.lcm(-12,15)
