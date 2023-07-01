import matplotlib.pyplot as plt
import math


def nextPoint(x, y, angle):
    a = math.pi * angle / 180
    x2 = (int)(round(x + (1 * math.cos(a))))
    y2 = (int)(round(y + (1 * math.sin(a))))
    return x2, y2


def expand(axiom, rules, level):
    for l in range(0, level):
        a2 = ""
        for c in axiom:
            if c in rules:
                a2 += rules[c]
            else:
                a2 += c
        axiom = a2
    return axiom


def draw_lsystem(axiom, rules, angle, iterations):
    xp = [1]
    yp = [1]
    direction = 0
    for c in expand(axiom, rules, iterations):
        if c == "F":
            xn, yn = nextPoint(xp[-1], yp[-1], direction)
            xp.append(xn)
            yp.append(yn)
        elif c == "-":
            direction = direction - angle
            if direction < 0:
                direction = 360 + direction
        elif c == "+":
            direction = (direction + angle) % 360

    plt.plot(xp, yp)
    plt.show()


if __name__ == '__main__':
    # Sierpinski Arrowhead Curve L-System Definition
    s_axiom = "XF"
    s_rules = {"X": "YF+XF+Y",
               "Y": "XF-YF-X"}
    s_angle = 60

    draw_lsystem(s_axiom, s_rules, s_angle, 7)
