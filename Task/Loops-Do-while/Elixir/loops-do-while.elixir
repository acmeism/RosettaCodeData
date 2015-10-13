defmodule Loops do
  def do_while(n) do
    n1 = n + 1
    IO.puts n1
    if rem(n1, 6) == 0, do: :ok,
                      else: do_while(n1)
  end
end

Loops.do_while(0)
