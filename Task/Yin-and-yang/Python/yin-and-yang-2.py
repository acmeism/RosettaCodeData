from turtle import *

mode('logo')

def taijitu(r):
  '''\
  Draw a classic Taoist taijitu of the given radius centered on the current
  turtle position. The "eyes" are placed along the turtle's heading, the
  filled one in front, the open one behind.
  '''

  # useful derivative values
  r2, r4, r8 = (r >> s for s in (1, 2, 3))

  # remember where we started
  x0, y0 = start = pos()
  startcolour = color()
  startheading = heading()
  color('black', 'black')

  # draw outer circle
  pendown()
  circle(r)

  # draw two 'fishes'
  begin_fill(); circle(r, 180); circle(r2, 180); circle(-r2, 180); end_fill()

  # black 'eye'
  setheading(0); penup(); goto(-(r4 + r8) + x0, y0); pendown()
  begin_fill(); circle(r8); end_fill()

  # white 'eye'
  color('white', 'white'); setheading(0); penup(); goto(-(r+r4+r8) + x0, y0); pendown()
  begin_fill(); circle(r8); end_fill()

  # put the turtle back where it started
  penup()
  setpos(start)
  setheading(startheading)
  color(*startcolour)


if __name__ == '__main__':
  # demo code to produce image at right
  reset()
  #hideturtle()
  penup()
  goto(300, 200)
  taijitu(200)
  penup()
  goto(-150, -150)
  taijitu(100)
  hideturtle()
