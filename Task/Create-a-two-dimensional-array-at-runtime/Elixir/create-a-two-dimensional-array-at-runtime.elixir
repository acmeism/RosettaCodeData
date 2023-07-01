defmodule TwoDimArray do

  def create(w, h) do
    List.duplicate(0, w)
      |> List.duplicate(h)
  end

  def set(arr, x, y, value) do
    List.replace_at(arr, x,
      List.replace_at(Enum.at(arr, x), y, value)
    )
  end

  def get(arr, x, y) do
    arr |> Enum.at(x) |> Enum.at(y)
  end
end


width = IO.gets "Enter Array Width: "
w = width |> String.trim() |> String.to_integer()

height = IO.gets "Enter Array Height: "
h = height |> String.trim() |> String.to_integer()

arr = TwoDimArray.create(w, h)
arr = TwoDimArray.set(arr,2,0,42)

IO.puts(TwoDimArray.get(arr,2,0))
