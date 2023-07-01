import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import hsv_to_rgb as hsv

def curve(axiom, rules, angle, depth):
    for _ in range(depth):
        axiom = ''.join(rules[c] if c in rules else c for c in axiom)

    a, x, y = 0, [0], [0]
    for c in axiom:
        match c:
            case '+':
                a += 1
            case '-':
                a -= 1
            case 'F' | 'G':
                x.append(x[-1] + np.cos(a*angle*np.pi/180))
                y.append(y[-1] + np.sin(a*angle*np.pi/180))

    l = len(x)
    # this is very slow, but pretty colors
    for i in range(l - 1):
        plt.plot(x[i:i+2], y[i:i+2], color=hsv([i/l, 1, .7]))
    plt.gca().set_aspect(1)
    plt.show()

curve('F++F++F', {'F': 'F+F--F+F'}, 60, 5)
#curve('F--XF--F--XF', {'X': 'XF+G+XF--F--XF+G+X'}, 45, 5)
#curve('F+XF+F+XF', {'X': 'XF-F+F-XF+F+XF-F+F-X'}, 90, 5)
#curve('F', {'F': 'G-F-G', 'G': 'F+G+F'}, 60, 7)
#curve('A', {'A': '+BF-AFA-FB+', 'B': '-AF+BFB+FA-'}, 90, 6)
#curve('FX+FX+', {'X': 'X+YF', 'Y': 'FX-Y'}, 90, 12)
