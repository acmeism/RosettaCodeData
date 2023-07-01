#!/usr/bin/python

def a(n):
    n += 2
    return n*(n**2 + 1)/2

def inv_a(x):
    k = 0
    while k*(k**2+1)/2+2 < x:
        k+=1
    return k


if __name__ == '__main__':
    print("The first 20 magic constants are:");
    for n in range(1, 20):
        print(int(a(n)), end = " ");
    print("\nThe 1,000th magic constant is:",int(a(1000)));

    for e in range(1, 20):
        print(f'10^{e}: {inv_a(10**e)}');
