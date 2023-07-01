import std
def lcs2(a, b) -> string:
    var out = ""
    let lengths = map(b.length): map(a.length): 0
    var greatestLength = 0
    for(a) x, i:
        for(b) y, j:
            if x == y:
                if i == 0 or j == 0:
                    lengths[j][i] = 1
                else:
                    lengths[j][i] = lengths[j-1][i-1] + 1
                if lengths[j][i] > greatestLength:
                    greatestLength = lengths[j][i]
                    out = a.substring(i - greatestLength + 1, greatestLength)
    return out
