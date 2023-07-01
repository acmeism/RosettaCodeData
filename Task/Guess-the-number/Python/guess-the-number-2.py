import random #milliard.py
h1 = 0; h2 = 10**16; t = 0; f=0
c = random.randrange(0,h2) #comp
h = random.randrange(0,h2) #human DANILIN

while f<1:
    print(t,c,h)

    if h<c:
        print('MORE')
        a=h
        h=int((h+h2)/2)
        h1=a

    elif h>c:
        print('less')
        a=h
        h=int((h1+h)/2)
        h2=a

    else:
        print('win by', t, 'steps')
        f=1
    t=t+1
