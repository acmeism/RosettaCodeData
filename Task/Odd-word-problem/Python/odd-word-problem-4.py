from sys import stdin, stdout

def fwd(c):
    if c.isalpha():
        return [stdout.write(c), (yield from fwd((yield f)))][1]
    else:
        return c

def rev(c):
    if c.isalpha():
        return [(yield from rev((yield r))), stdout.write(c)][0]
    else:
        return c

def fw():
    while True:
        stdout.write((yield from fwd((yield r))))

def re():
    while True:
        stdout.write((yield from rev((yield f))))

f = fw()
r = re()
next(f)
next(r)

coro = f
while True:
    c = stdin.read(1)
    if not c:
        break
    coro = coro.send(c)
