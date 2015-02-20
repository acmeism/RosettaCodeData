gifts = '''\
A partridge in a pear tree.
Two turtle doves
Three french hens
Four calling birds
Five golden rings
Six geese a-laying
Seven swans a-swimming
Eight maids a-milking
Nine ladies dancing
Ten lords a-leaping
Eleven pipers piping
Twelve drummers drumming'''.split('\n')

days = '''first second third fourth fifth
          sixth seventh eighth ninth tenth
          eleventh twelfth'''.split()

for n, day in enumerate(days, 1):
    g = gifts[:n][::-1]
    print(('\nOn the %s day of Christmas\nMy true love gave to me:\n' % day) +
          '\n'.join(g[:-1]) +
          (' and\n' + g[-1] if n > 1 else g[-1].capitalize()))
