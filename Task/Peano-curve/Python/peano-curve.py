import turtle as tt
import inspect

stack = [] # Mark the current stacks in run.
def peano(iterations=1):
    global stack

    # The turtle Ivan:
    ivan = tt.Turtle(shape = "classic", visible = True)


    # The app window:
    screen = tt.Screen()
    screen.title("Desenhin do Peano")
    screen.bgcolor("#232323")
    screen.delay(0) # Speed on drawing (if higher, more slow)
    screen.setup(width=0.95, height=0.9)

    # The size of each step walked (here, named simply "walk"). It's not a pixel scale. This may stay still:
    walk = 1

    def screenlength(k):
        # A function to make the image good to see (without it would result in a partial image).
        # This will guarantee that we can see the the voids and it's steps.
        if k != 0:
            length = screenlength(k-1)
            return 2*length + 1
        else: return 0

    kkkj = screenlength(iterations)
    screen.setworldcoordinates(-1, -1, kkkj + 1, kkkj + 1)
    ivan.color("#EEFFFF", "#FFFFFF")


    # The magic  \(^-^)/:
    def step1(k):
        global stack
        stack.append(len(inspect.stack()))
        if k != 0:
            ivan.left(90)
            step2(k - 1)
            ivan.forward(walk)
            ivan.right(90)
            step1(k - 1)
            ivan.forward(walk)
            step1(k - 1)
            ivan.right(90)
            ivan.forward(walk)
            step2(k - 1)
            ivan.left(90)
    def step2(k):
        global stack
        stack.append(len(inspect.stack()))
        if k != 0:
            ivan.right(90)
            step1(k - 1)
            ivan.forward(walk)
            ivan.left(90)
            step2(k - 1)
            ivan.forward(walk)
            step2(k - 1)
            ivan.left(90)
            ivan.forward(walk)
            step1(k - 1)
            ivan.right(90)

    # Making the program work:
    ivan.left(90)
    step2(iterations)

    tt.done()

if __name__ == "__main__":
    peano(4)
    import pylab as P # This plot, after closing the drawing window, the "stack" graphic.
    P.plot(stack)
    P.show()
