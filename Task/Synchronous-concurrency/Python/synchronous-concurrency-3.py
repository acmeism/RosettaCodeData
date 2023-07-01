def reader():
    for line in open('input.txt'):
        yield line.rstrip()
    count = yield None
    print('Printed %d lines.' % count)

r = reader()

# printer
for count, line in enumerate(r):
    if line is None:
        break
    print(line)
try:
    r.send(count)
except StopIteration:
    pass
