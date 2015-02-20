from functools import wraps
from turtle import *

def memoize(obj):
    cache = obj.cache = {}
    @wraps(obj)
    def memoizer(*args, **kwargs):
        key = str(args) + str(kwargs)
        if key not in cache:
            cache[key] = obj(*args, **kwargs)
        return cache[key]
    return memoizer

@memoize
def fibonacci_word(n):
    assert n > 0
    if n == 1:
        return "1"
    if n == 2:
        return "0"
    return fibonacci_word(n - 1) + fibonacci_word(n - 2)

def draw_fractal(word, step):
    for i, c in enumerate(word, 1):
        forward(step)
        if c == "0":
            if i % 2 == 0:
                left(90)
            else:
                right(90)

def main():
    n = 25 # Fibonacci Word to use.
    step = 1 # Segment length.
    width = 1050 # Width of plot area.
    height = 1050 # Height of plot area.
    w = fibonacci_word(n)

    setup(width=width, height=height)
    speed(0)
    setheading(90)
    left(90)
    penup()
    forward(500)
    right(90)
    backward(500)
    pendown()
    tracer(10000)
    hideturtle()

    draw_fractal(w, step)

    # Save Poscript image.
    getscreen().getcanvas().postscript(file="fibonacci_word_fractal.eps")
    exitonclick()

if __name__ == '__main__':
    main()
