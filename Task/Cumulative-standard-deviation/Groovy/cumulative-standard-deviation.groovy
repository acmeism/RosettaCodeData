List samples = []

def stdDev = { def sample ->
    samples << sample
    def sum = samples.sum()
    def sumSq = samples.sum { it * it }
    def count = samples.size()
    (sumSq/count - (sum/count)**2)**0.5
}

[2,4,4,4,5,5,7,9].each {
    println "${stdDev(it)}"
}
