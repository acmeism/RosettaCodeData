defmodule RC do
  def expansion(range) do
    Enum.flat_map(String.split(range, ","), fn part ->
      case Regex.scan(~r/^(-?\d+)-(-?\d+)$/, part) do
        [[_,a,b]] -> Enum.to_list(String.to_integer(a) .. String.to_integer(b))
        [] -> [String.to_integer(part)]
      end
    end)
  end
end

IO.inspect RC.expansion("-6,-3--1,3-5,7-11,14,15,17-20")
