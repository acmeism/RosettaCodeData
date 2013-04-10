a = {x = 1; y = 2}
b = {x = 3; y = 4}
c = {
    x = a.x + b.x;
    y = a.y + b.y
}
print(a.x, a.y)  --> 1 2
print(c.x, c.y)  --> 4 6
