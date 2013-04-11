flatten = (arr) ->
  arr.reduce ((xs, el) ->
    if Array.isArray el
      xs.concat flatten el
    else
      xs.concat [el]), []

# test
list = [[1], 2, [[3,4], 5], [[[]]], [[[6]]], 7, 8, []]
console.log flatten list
