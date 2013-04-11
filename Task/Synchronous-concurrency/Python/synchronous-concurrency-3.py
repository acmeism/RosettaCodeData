def reader():
    for line in open('input.txt'):
        yield line.rstrip()
    count = yield None
    print('Printed %d lines.' % count)

r = reader()
# printer
count = 0
while True:
    line = next(r)
    if not line:
        break
    print(line)
    count += 1
r.send(count)
