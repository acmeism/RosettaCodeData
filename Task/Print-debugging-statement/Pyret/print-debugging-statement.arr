fun add(x, y):
  result = x + y
  spy "in add":
    x,
    y,
    result,
    result-plus-one: result + 1
  end
  result
end

add(2, 7)
