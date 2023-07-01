def print_verse(n):
    l = ['b', 'f', 'm']
    s = n[1:]
    if str.lower(n[0]) in l:
        l[l.index(str.lower(n[0]))] = ''
    elif n[0] in ['A', 'E', 'I', 'O', 'U']:
        s = str.lower(n)
    print('{0}, {0}, bo-{2}{1}\nBanana-fana fo-{3}{1}\nFee-fi-mo-{4}{1}\n{0}!\n'.format(n, s, *l))

# Assume that the names are in title-case and they're more than one character long
for n in ['Gary', 'Earl', 'Billy', 'Felix', 'Mary']:
    print_verse(n)
