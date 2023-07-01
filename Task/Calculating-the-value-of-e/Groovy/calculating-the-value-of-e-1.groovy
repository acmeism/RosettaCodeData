def ε = 1.0e-15
def φ = 1/ε

def generateAddends = {
    def addends = []
    def n = 0.0
    def fact = 1.0
    while (true) {
        fact *= (n < 2 ? 1.0 : n) as double
        addends << 1.0/fact
        if (fact > φ) break // any further addends would not pass the tolerance test
        n++
    }
    addends.sort(false) // smallest addends first for better response to rounding error
}

def e = generateAddends().sum()
