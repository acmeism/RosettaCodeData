I = (P) ->
  # The cryptic name "I" follows the problem description;
  # it returns a function that computes a moving average
  # of successive values over the period P, using closure
  # variables to maintain state.
  cq = circular_queue(P)
  num_elems = 0
  sum = 0

  SMA = (n) ->
    sum += n
    if num_elems < P
      cq.add(n)
      num_elems += 1
      sum / num_elems
    else
      old = cq.replace(n)
      sum -= old
      sum / P

circular_queue = (n) ->
  # queue that only ever stores up to n values;
  # Caller shouldn't call replace until n values
  # have been added.
  i = 0
  arr = []

  add: (elem) ->
    arr.push elem
  replace: (elem) ->
    # return value whose age is "n"
    old_val = arr[i]
    arr[i] = elem
    i = (i + 1) % n
    old_val

# The output of the code below should convince you that
# calling I multiple times returns functions with independent
# state.
sma3 = I(3)
sma7 = I(7)
sma11 = I(11)
for i in [1..10]
  console.log i, sma3(i), sma7(i), sma11(i)
