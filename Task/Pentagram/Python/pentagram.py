import turtle

turtle.bgcolor("green")
t = turtle.Turtle()
t.color("red", "blue")
t.begin_fill()
for i in range(0, 5):
    t.forward(200)
    t.right(144)
t.end_fill()
