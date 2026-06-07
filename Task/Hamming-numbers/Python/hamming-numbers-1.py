from itertools import islice

def hamming2():
    '''\
    This version is based on a snippet from:
        https://web.archive.org/web/20081219014725/http://dobbscodetalk.com:80
                         /index.php?option=com_content&task=view&id=913&Itemid=85
        http://www.drdobbs.com/architecture-and-design/hamming-problem/228700538
        Hamming problem
        Written by Will Ness
        December 07, 2008

        When expressed in some imaginary pseudo-C with automatic
        unlimited storage allocation and BIGNUM arithmetics, it can be
        expressed as:
            hamming = h where
              array h;
              n=0; h[0]=1; i=0; j=0; k=0;
              x2=2*h[ i ]; x3=3*h[j]; x5=5*h[k];
              repeat:
                h[++n] = min(x2,x3,x5);
                if (x2==h[n]) { x2=2*h[++i]; }
                if (x3==h[n]) { x3=3*h[++j]; }
                if (x5==h[n]) { x5=5*h[++k]; }
    '''
    h = 1
    _h = [h]    # memoized
    multipliers  = (2, 3, 5)
    multindices  = [0 for _ in multipliers] # index into _h for multipliers
    multvalues   = [x * _h[i] for x, i in zip(multipliers, multindices)]
    yield h
    while True:
        h = min(multvalues)
        _h.append(h)
        for (n, (v, x, i)) in enumerate(zip(multvalues, multipliers, multindices)):
            if v == h:
                i += 1
                multindices[n] = i
                multvalues[n]  = x * _h[i]
        # cap the memoization
        mini = min(multindices)
        if mini >= 1000:
            del _h[:mini]
            multindices = [i - mini for i in multindices]
        #
        yield h

print(list(islice(hamming2(), 20)))
print(list(islice(hamming2(), 1690, 1691)))
print(list(islice(hamming2(), 999999, 1000000)))
