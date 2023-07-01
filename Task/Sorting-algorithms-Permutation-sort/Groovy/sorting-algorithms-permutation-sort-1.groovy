def factorial = { (it > 1) ? (2..it).inject(1) { i, j -> i*j } : 1 }

def makePermutation;
makePermutation = { list, i ->
    def n = list.size()
    if (n < 2) return list
    def fact = factorial(n-1)
    assert i < fact*n

    def index = i.intdiv(fact)
    [list[index]] + makePermutation(list[0..<index] + list[(index+1)..<n], i % fact)
}

def sorted = { a -> (1..<(a.size())).every { a[it-1] <= a[it] } }

def permutationSort = { a ->
    def n = a.size()
    def fact = factorial(n)
    def permuteA = makePermutation.curry(a)
    def pIndex = (0..<fact).find { print "."; sorted(permuteA(it)) }
    permuteA(pIndex)
}
