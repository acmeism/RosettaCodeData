defmodule Test do
  def integer?(n) when n == trunc(n), do: true
  def integer?(_), do: false
end

Enum.each([2, 2.0, 2.5, 2.000000000000001, 1.23e300, 1.0e-300, "123", '123', :"123"], fn n ->
  IO.puts "#{inspect n} is integer?: #{Test.integer?(n)}"
end)
