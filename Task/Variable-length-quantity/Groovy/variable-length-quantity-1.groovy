final RADIX = 7
final MASK = 2**RADIX - 1

def octetify = { n ->
    def octets = []
    for (def i = n; i != 0; i >>>= RADIX) {
        octets << ((byte)((i & MASK) + (octets.empty ? 0 : MASK + 1)))
    }
    octets.reverse()
}

def deoctetify = { octets ->
    octets.inject(0) { long n, octet ->
        (n << RADIX) + ((int)(octet) & MASK)
    }
}
