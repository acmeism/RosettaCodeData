from turtle import goto, pu, pd, color, done

def level(ax, ay, bx, by, depth=0):
    if depth > 0:
        dx,dy = bx-ax, ay-by
        x3,y3 = bx-dy, by-dx
        x4,y4 = ax-dy, ay-dx
        x5,y5 = x4 + (dx - dy)/2, y4 - (dx + dy)/2
        goto(ax, ay), pd()
        for x, y in ((bx, by), (x3, y3), (x4, y4), (ax, ay)):
            goto(x, y)
        pu()
        level(x4,y4, x5,y5, depth - 1)
        level(x5,y5, x3,y3, depth - 1)

if __name__ == '__main__':
    color('red', 'yellow')
    pu()
    level(-100, 500, 100, 500, depth=8)
    done()
