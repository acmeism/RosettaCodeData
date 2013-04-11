def random = new Random()

def factorial = { (it > 1) ? (2..it).inject(1) { i, j -> i*j } : 1 }

def makePermutation;
makePermutation = { string, i ->
    def n = string.size()
    if (n < 2) return string
    def fact = factorial(n-1)
    assert i < fact*n

    def index = i.intdiv(fact)
    string[index] + makePermutation(string[0..<index] + string[(index+1)..<n], i % fact)
}

def randomBrackets = { n ->
    if (n == 0) return ''
    def base = '['*n + ']'*n
    def p = random.nextInt(factorial(n*2))
    makePermutation(base, p)
}
