NUM_POINTS = 100
MIN_R = 10
MAX_R = 15

random_circle_points = ->
  rand_point = ->
    Math.floor (Math.random() * (MAX_R * 2 + 1) - MAX_R)

  points = {}
  cnt = 0
  while cnt < 100
    x = rand_point()
    y = rand_point()
    continue unless MIN_R * MIN_R <= x*x + y*y <= MAX_R * MAX_R
    points["#{x},#{y}"] = true
    cnt += 1
  points

plot = (points) ->
  range = [-1 * MAX_R .. MAX_R]
  for y in range
    s = ''
    for x in range
      s += if points["#{x},#{y}"] then '*' else ' '
    console.log s

plot random_circle_points()
