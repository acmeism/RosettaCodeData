VERSE = '''\
{n} bottle{s} of beer on the wall
{n} bottle{s} of beer
Take one down, pass it around
{n_minus_1} bottle{s2} of beer on the wall

'''


for n in range(99, 0, -1):
    if n == 1:
        n_minus_1 = 'No more'
        s = ''
        s2 = 's'
    elif n == 2:
        n_minus_1 = n - 1;
        s = 's'
        s2 = ''
    else:
        n_minus_1 = n - 1;
        s = 's'
        s2 = 's'


    print(VERSE.format(n=n, s=s, s2=s2, n_minus_1=n_minus_1))
