defmodule RC do
  def largest_int(list) do
    sorted = Enum.sort(list, fn x,y -> "#{x}#{y}" >= "#{y}#{x}" end)
    Enum.join(sorted)
  end
end

IO.inspect RC.largest_int [1, 34, 3, 98, 9, 76, 45, 4]
IO.inspect RC.largest_int [54, 546, 548, 60]
