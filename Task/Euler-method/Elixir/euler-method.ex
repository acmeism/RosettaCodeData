defmodule Euler do
  def method(_, _, t, b, _) when t>b, do: :ok
  def method(f, y, t, b, h) do
    :io.format "~7.3f ~7.3f~n", [t,y]
    method(f, y + h * f.(t,y), t + h, b, h)
  end
end

f = fn _time, temp -> -0.07 * (temp - 20) end
Enum.each([10, 5, 2], fn step ->
  IO.puts "\nStep = #{step}"
  Euler.method(f, 100.0, 0.0, 100.0, step)
end)
