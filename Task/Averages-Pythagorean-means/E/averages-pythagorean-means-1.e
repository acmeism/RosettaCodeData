def makeMean(base, include, finish) {
    return def mean(numbers) {
        var count := 0
        var acc := base
        for x in numbers {
            acc := include(acc, x)
            count += 1
        }
        return finish(acc, count)
    }
}

def A := makeMean(0, fn b,x { b+x   }, fn acc,n { acc / n      })
def G := makeMean(1, fn b,x { b*x   }, fn acc,n { acc ** (1/n) })
def H := makeMean(0, fn b,x { b+1/x }, fn acc,n { n / acc      })
