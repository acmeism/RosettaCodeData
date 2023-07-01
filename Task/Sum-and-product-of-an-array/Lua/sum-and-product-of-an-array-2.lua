function table.sum(arr, length)
      --same as if <> then <> else <>
      return length == 1 and arr[1] or arr[length] + table.sum(arr, length -1)
end

function table.product(arr, length)
      return length == 1 and arr[1] or arr[length] * table.product(arr, length -1)
end

t = {1,2,3}
print(table.sum(t,#t))
print(table.product(t,3))
