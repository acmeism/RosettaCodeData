defmodule Loops do
  def loops_for(n) do
    Enum.each(1..n, fn i ->
      Enum.each(1..i, fn _ -> IO.write "*" end)
      IO.puts ""
    end)
  end
end

Loops.loops_for(5)
