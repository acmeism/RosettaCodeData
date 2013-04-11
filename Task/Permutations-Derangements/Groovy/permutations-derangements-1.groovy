def fact = { n -> [1,(1..<(n+1)).inject(1) { prod, i -> prod * i }].max() }
def subfact
subfact = { BigInteger n -> (n == 0) ? 1 : (n == 1) ? 0 : ((n-1) * (subfact(n-1) + subfact(n-2))) }

def derangement = { List l ->
    def d = []
    l.eachPermutation { p -> if ([p,l].transpose().every{ it[0] != it[1] }) d << p }
    d
}
