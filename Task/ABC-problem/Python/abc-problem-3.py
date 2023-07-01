def mkword(w, b):
    if not w: return []

    c,w = w[0],w[1:]
    for i in range(len(b)):
        if c in b[i]:
            m = mkword(w, b[0:i] + b[i+1:])
            if m != None: return [b[i]] + m

def abc(w, blk):
    return mkword(w.upper(), [a.upper() for a in blk])

blocks = 'BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM'.split()

for w in ", A, bark, book, treat, common, SQUAD, conFUsEd".split(', '):
    print '\'' + w + '\'' + ' ->', abc(w, blocks)
