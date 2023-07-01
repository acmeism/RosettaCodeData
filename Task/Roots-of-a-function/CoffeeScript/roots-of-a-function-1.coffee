print_roots = (f, begin, end, step) ->
  # Print approximate roots of f between x=begin and x=end,
  # using sign changes as an indicator that a root has been
  # encountered.
  x = begin
  y = f(x)
  last_y = y

  cross_x_axis = ->
    (last_y < 0 and y > 0) or (last_y > 0 and y < 0)

  console.log '-----'
  while x <= end
    y = f(x)
    if y == 0
      console.log "Root found at", x
    else if cross_x_axis()
      console.log "Root found near", x
    x += step
    last_y = y

do ->
  # Smaller steps produce more accurate/precise results in general,
  # but for many functions we'll never get exact roots, either due
  # to imperfect binary representation or irrational roots.
  step = 1 / 256

  f1 = (x) -> x*x*x - 3*x*x + 2*x
  print_roots f1, -1, 5, step
  f2 = (x) -> x*x - 4*x + 3
  print_roots f2, -1, 5, step
  f3 = (x) -> x - 1.5
  print_roots f3, 0, 4, step
  f4 = (x) -> x*x - 2
  print_roots f4, -2, 2, step
