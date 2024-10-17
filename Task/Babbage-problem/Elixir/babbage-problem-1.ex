defmodule Babbage do
  def problem(n) when rem(n*n,1000000)==269696, do: n
  def problem(n), do: problem(n+2)
end

IO.puts Babbage.problem(0)
