print_multiplication_tables = (n) ->
  width = 4

  pad = (s, n=width, c=' ') ->
    s = s.toString()
    result = ''
    padding = n - s.length
    while result.length < padding
      result += c
    result + s

  s = pad('') + '|'
  for i in [1..n]
    s += pad i
  console.log s

  s = pad('', width, '-') + '+'
  for i in [1..n]
    s += pad '', width, '-'
  console.log s


  for i in [1..n]
    s = pad i
    s += '|'
    s += pad '', width*(i - 1)
    for j in [i..n]
       s += pad i*j
    console.log s

print_multiplication_tables 12
