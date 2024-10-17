defmodule Binary do
  def search(list, value), do: search(List.to_tuple(list), value, 0, length(list)-1)

  def search(_tuple, _value, low, high) when high < low, do: :not_found
  def search(tuple, value, low, high) do
    mid = div(low + high, 2)
    midval = elem(tuple, mid)
    cond do
      value <  midval -> search(tuple, value, low, mid-1)
      value >  midval -> search(tuple, value, mid+1, high)
      value == midval -> mid
    end
  end
end

list = [0,1,4,5,6,7,8,9,12,26,45,67,78,90,98,123,211,234,456,769,865,2345,3215,14345,24324]
Enum.each([0,42,45,24324,99999], fn val ->
  case Binary.search(list, val) do
    :not_found -> IO.puts "#{val} not found in list"
    index      -> IO.puts "found #{val} at index #{index}"
  end
end)
