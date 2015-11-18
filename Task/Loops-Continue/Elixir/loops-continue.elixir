defmodule Loops do
  def continue do
    Enum.each(1..10, fn i ->
      IO.write i
      IO.write if rem(i,5)==0, do: "\n", else: ", "
    end)
  end
end

Loops.continue
