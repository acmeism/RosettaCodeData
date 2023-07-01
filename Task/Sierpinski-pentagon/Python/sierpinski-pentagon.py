from turtle import *
import math
speed(0)      # 0 is the fastest speed. Otherwise, 1 (slow) to 10 (fast)
hideturtle()  # hide the default turtle

part_ratio = 2 * math.cos(math.radians(72))
side_ratio = 1 / (part_ratio + 2)

hide_turtles = True   # show/hide turtles as they draw
path_color = "black"  # path color
fill_color = "black"  # fill color

# turtle, size
def pentagon(t, s):
  t.color(path_color, fill_color)
  t.pendown()
  t.right(36)
  t.begin_fill()
  for i in range(5):
    t.forward(s)
    t.right(72)
  t.end_fill()

# iteration, turtle, size
def sierpinski(i, t, s):
  t.setheading(0)
  new_size = s * side_ratio

  if i > 1:
    i -= 1

    # create four more turtles
    for j in range(4):
      t.right(36)
      short = s * side_ratio / part_ratio
      dist = [short, s, s, short][j]

      # spawn a turtle
      spawn = Turtle()
      if hide_turtles:spawn.hideturtle()
      spawn.penup()
      spawn.setposition(t.position())
      spawn.setheading(t.heading())
      spawn.forward(dist)

      # recurse for spawned turtles
      sierpinski(i, spawn, new_size)

    # recurse for parent turtle
    sierpinski(i, t, new_size)

  else:
    # draw a pentagon
    pentagon(t, s)
    # delete turtle
    del t

def main():
  t = Turtle()
  t.hideturtle()
  t.penup()
  screen = t.getscreen()
  y = screen.window_height()
  t.goto(0, y/2-20)

  i = 5       # depth. i >= 1
  size = 300  # side length

  # so the spawned turtles move only the distance to an inner pentagon
  size *= part_ratio

  # begin recursion
  sierpinski(i, t, size)

main()
