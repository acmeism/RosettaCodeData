import std
def lcs(a, b) -> string:
    var out = ""
    let lengths = map(a.length * b.length): 0
    var greatestLength = 0
    for(a) x, i:
        for(b) y, j:
            if x == y:
                if i == 0 or j == 0:
                    lengths[i * b.length + j] = 1
                else:
                    lengths[i * b.length + j] = lengths[(i-1) * b.length + j - 1] + 1
                if lengths[i * b.length + j] > greatestLength:
                    greatestLength = lengths[i * b.length + j]
                    out = a.substring(i - greatestLength + 1, greatestLength)
    return out
