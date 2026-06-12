''' rosettacode.org/wiki/Inventory_sequence '''
from collections import Counter
from matplotlib.pyplot import plot

def inventory_sequence(terms):
    ''' From the code by Branicky at oeis.org/A342585 '''
    num, alst, inventory = 0, [0], Counter([0])
    for n in range(2, terms+1):
        c = inventory[num]
        num = 0 if c == 0 else num + 1
        alst.append(c)
        inventory.update([c])
    return alst

biglist = inventory_sequence(201_790)
thresholds = [1000 * j for j in range(1, 11)]

for i, k in enumerate(biglist):
    if i < 100:
        print(f'{k:<4}', end='\n' if (i + 1) % 20 == 0 else '')
    elif k >= thresholds[0]:
        print(f'\nFirst element >= {thresholds.pop(0):5}: {k:5} in position {i:6}')
        if len(thresholds) == 0:
               break

plot(biglist[:10_000], linewidth=0.3)
plt.show()
