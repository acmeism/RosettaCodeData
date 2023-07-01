def d = derangement([1,2,3,4])
assert d.size() == subfact(4)
d.each { println it }

println """
n   # derangements   subfactorial
=   ==============   ============"""
(0..9). each { n ->
    def dr = derangement((1..<(n+1)) as List)
    def sf = subfact(n)
    printf('%1d   %14d   %12d\n', n, dr.size(), sf)
}

println """
!20 == ${subfact(20)}
"""
