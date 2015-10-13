#!/usr/bin/env python3

def ord(n):
    try:
        s = ['st', 'nd', 'rd'][(n-1)%10]
        if (n-10)%100//10:
            return str(n)+s
    except IndexError:
        pass
    return str(n)+'th'

if __name__ == '__main__':
    print(*(ord(n) for n in range(26)))
    print(*(ord(n) for n in range(250,266)))
    print(*(ord(n) for n in range(1000,1026)))
