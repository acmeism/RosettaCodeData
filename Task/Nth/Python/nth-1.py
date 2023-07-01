_suffix = ['th', 'st', 'nd', 'rd', 'th', 'th', 'th', 'th', 'th', 'th']

def nth(n):
    return "%i'%s" % (n, _suffix[n%10] if n % 100 <= 10 or n % 100 > 20 else 'th')

if __name__ == '__main__':
    for j in range(0,1001, 250):
        print(' '.join(nth(i) for i in list(range(j, j+25))))
