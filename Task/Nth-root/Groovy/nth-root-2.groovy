class Constants {
    static final tolerance = 0.00001
}

print '''
   Base   Power  Calc'd Root  Actual Root
-------  ------  -----------  -----------
'''
def testCases = [
    [b:32.0, n:5.0, r:2.0],
    [b:81.0, n:4.0, r:3.0],
    [b:Math.PI**2, n:4.0, r:Math.PI**(0.5)],
    [b:7.0, n:0.5, r:49.0],
]

testCases.each {
    def r = root(it.b, it.n)
    printf('%7.4f  %6.4f  %11.4f  %11.4f\n',
        it.b, it.n, r, it.r)
    assert (r - it.r).abs() <= tolerance
}
