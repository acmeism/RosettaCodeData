def getitem(s, depth=0):
    out = [""]
    while s:
        c = s[0]
        if depth and (c == ',' or c == '}'):
            return out,s
        if c == '{':
            x = getgroup(s[1:], depth+1)
            if x:
                out,s = [a+b for a in out for b in x[0]], x[1]
                continue
        if c == '\\' and len(s) > 1:
            s, c = s[1:], c + s[1]

        out, s = [a+c for a in out], s[1:]

    return out,s

def getgroup(s, depth):
    out, comma = [], False
    while s:
        g,s = getitem(s, depth)
        if not s: break
        out += g

        if s[0] == '}':
            if comma: return out, s[1:]
            return ['{' + a + '}' for a in out], s[1:]

        if s[0] == ',':
            comma,s = True, s[1:]

    return None

# stolen cowbells from Raku example
for s in '''~/{Downloads,Pictures}/*.{jpg,gif,png}
It{{em,alic}iz,erat}e{d,}, please.
{,{,gotta have{ ,\, again\, }}more }cowbell!
{}} some }{,{\\\\{ edge, edge} \,}{ cases, {here} \\\\\\\\\}'''.split('\n'):
    print "\n\t".join([s] + getitem(s)[0]) + "\n"
