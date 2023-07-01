count = 0

def reader():
    for line in open('input.txt'):
        yield line.rstrip()
    print('Printed %d lines.' % count)

r = reader()
# printer
for line in r:
    print(line)
    count += 1
