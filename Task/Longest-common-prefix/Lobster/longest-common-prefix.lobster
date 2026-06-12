// lcp finds the longest common prefix of the input strings

def lcp(l):
    // Special cases first
    let len = l.length
    if len == 0:
        return ""
    else: if len == 1:
        return l[0]
    // LCP of min and max (lexigraphically) is the LCP of the whole set
    var min, max = l[0], l[0]
    for(l) s, i:
        if i > 0:
            if s < min:
                min = s
            else: if s > max:
                max = s
    let slen = min(min.length, max.length)
    if slen == 0:
        return ""
    for(slen) i:
        if min[i] != max[i]:
            return min.substring(0, i)
    // In the case where lengths are not equal but all bytes
    // are equal, min is the answer ("foo" < "foobar")
    return min

for([["interspecies", "interstellar", "interstate"],
    ["throne", "throne"],
    ["throne", "dungeon"],
    ["throne", "", "throne"],
    ["cheese"],
    [""],
    [],
    ["prefix", "suffix"],
    ["foo", "foobar"]]):
        print("lcp" + _ + " = \"" + lcp(_) + "\"")
