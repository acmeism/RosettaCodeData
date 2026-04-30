import turtle
turtle.setup(startx=0,starty=0)
t=turtle.Turtle()
screen=turtle.Screen()
screen.bgcolor("black")
digitsunitones=[
    lambda t:None,
    lambda t:[t.right(90),t.forward(100)],
    lambda t:[t.right(180),t.forward(100),t.right(270),t.forward(100)],
    lambda t:[t.right(135),t.forward(141)],
    lambda t:[t.right(180),t.forward(100),t.right(225),t.forward(141)],
    lambda t:[t.right(180),t.forward(100),t.right(225),t.forward(141),t.right(225),t.forward(100)],
    lambda t:[t.right(90),t.up(),t.forward(100),t.right(90),t.down(),t.forward(100)],
    lambda t:[t.right(90),t.forward(100),t.right(90),t.forward(100)],
    lambda t:[t.right(180),t.forward(100),t.right(270),t.forward(100),t.right(270),t.forward(100)],
    lambda t:[t.right(90),t.forward(100),t.right(90),t.forward(100),t.right(90),t.forward(100)]
    ]
digitsunittens=[
    lambda t:None,
    lambda t:[t.left(90),t.forward(100)],
    lambda t:[t.left(180),t.forward(100),t.left(270),t.forward(100)],
    lambda t:[t.left(135),t.forward(141)],
    lambda t:[t.left(180),t.forward(100),t.left(225),t.forward(141)],
    lambda t:[t.left(180),t.forward(100),t.left(225),t.forward(141),t.left(225),t.forward(100)],
    lambda t:[t.left(90),t.up(),t.forward(100),t.left(90),t.down(),t.forward(100)],
    lambda t:[t.left(90),t.forward(100),t.left(90),t.forward(100)],
    lambda t:[t.left(180),t.forward(100),t.left(270),t.forward(100),t.left(270),t.forward(100)],
    lambda t:[t.left(90),t.forward(100),t.left(90),t.forward(100),t.left(90),t.forward(100)]
    ]
def cistercianinput():
    number=input("Input number: ")[:4]
    cistercian(number)
def cistercian(number):
    t.color("white")
    t.pensize(5)
    t.right(90)
    t.up()
    t.forward(200)
    t.right(180)
    t.down()
    t.forward(400)
    while len(str(number))!=4:
        number="0"+number
    ones=int(number[3])
    tens=int(number[2])
    hundreds=int(number[1])
    thousands=int(number[0])
    digitsunitones[ones](t)
    t.up()
    t.goto(0,200)
    t.seth(90)
    t.down()
    digitsunittens[tens](t)
    t.up()
    t.goto(0,-200)
    t.seth(270)
    t.down()
    digitsunittens[hundreds](t)
    t.up()
    t.goto(0,-200)
    t.seth(270)
    t.down()
    digitsunitones[thousands](t)
    t.hideturtle()
while True:
    cistercianinput()
    input("Continue? ")
    t.reset()
