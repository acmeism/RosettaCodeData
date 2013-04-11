# This very limited BCD-based collection of functions
# makes it easy to count very large numbers.  All arrays
# start off with the ones columns in position zero.
# Using arrays of decimal-based digits to model integers
# doesn't make much sense for most tasks, but if you
# want to keep counting forever, this does the trick.

BcdInteger =
  from_string: (s) ->
    arr = []
    for c in s
      arr.unshift parseInt(c)
    arr

  render: (arr) ->
    s = ''
    for elem in arr
      s = elem.toString() + s
    s

  succ: (arr) ->
    arr = (elem for elem in arr)
    i = 0
    while arr[i] == 9
      arr[i] = 0
      i += 1
    arr[i] ||= 0
    arr[i] += 1
    arr

# To start counting from 1, change the next line!
big_int = BcdInteger.from_string "199999999999999999999999999999999999999999999999999999"
while true
  console.log BcdInteger.render big_int
  big_int = BcdInteger.succ big_int
