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

def RMS := makeMean(0, fn b,x { b+x**2 }, fn acc,n { (acc/n).sqrt() })
