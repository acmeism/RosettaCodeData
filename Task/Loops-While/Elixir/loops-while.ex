defmodule Loops do
  def while(0), do: :ok
  def while(n) do
    IO.puts n
    while( div(n,2) )
  end
end

Loops.while(1024)
