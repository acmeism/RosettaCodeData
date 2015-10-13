def wsieve():       # ideone.com/mqO25A
    wh11 = [ 2,4,2,4,6,2,6,4,2,4,6,6, 2,6,4,2,6,4,6,8,4,2,4,2,
             4,8,6,4,6,2,4,6,2,6,6,4, 2,4,6,2,6,4,2,4,2,10,2,10]
    cs = accumulate( chain( [11], cycle( wh11)))
    yield( next( cs))  # cf. ideone.com/WFv4f
    ps = wsieve()      #     codereview.stackexchange.com/q/92365/9064
    p = next(ps)       # 11         stackoverflow.com/q/30553925/849891
    psq = p*p          # 121
    D = dict( zip( accumulate( chain( [0], wh11)), count(0)))   # start from
    mults = {}
    for c in cs:
        if c in mults:
            wheel = mults.pop(c)
        elif c < psq:
            yield c ; continue
        else:          # c==psq:  map (p*) (roll wh from p) = roll (wh*p) from (p*p)
            x = [p*d for d in wh11]
            i = D[ (p-11) % 210]
            wheel = accumulate( chain( [psq+x[i]], cycle( x[i+1:] + x[:i+1])))
            p = next(ps) ; psq = p*p
        for m in wheel:
            if not m in mults:
                break
        mults[m] = wheel

def primes():
	yield from (2, 3, 5, 7)
	yield from wsieve()

print( list( islice( primes(), 0, 20)))
print( list( takewhile( lambda x: x<150,
                   dropwhile( lambda x: x<100, primes()))))
print( len( list( takewhile( lambda x: x<8000,
                   dropwhile( lambda x: x<7700, primes())))))
print( list( islice( primes(), 10000-1, 10000))[0])
