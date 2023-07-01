def grey_encode(n) -> int:
    return n ^ (n >> 1)

def grey_decode(n) -> int:
    var p = n
    n = n >> 1
    while n != 0:
        p = p ^ n
        n = n >> 1
    return p

for(32) i:
    let g = grey_encode(i)
    let b = grey_decode(g)
    print(number_to_string(i, 10, 2) + " : " +
          number_to_string(i,  2, 5) + " ⇾ " +
          number_to_string(g,  2, 5) + " ⇾ " +
          number_to_string(b,  2, 5) + " : " +
          number_to_string(b, 10, 2))
