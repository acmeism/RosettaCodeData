def rotate(enumerable, count) do
  {left, right} = Enum.split(enumerable, count)
  right ++ left
end

rotate(1..9, 3)
# [4, 5, 6, 7, 8, 9, 1, 2, 3]
