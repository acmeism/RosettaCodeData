verse = '''\
%i bottles of beer on the wall
%i bottles of beer
Take one down, pass it around
%i bottles of beer on the wall
'''

for bottles in range(99,0,-1):
    print verse % (bottles, bottles, bottles-1)
