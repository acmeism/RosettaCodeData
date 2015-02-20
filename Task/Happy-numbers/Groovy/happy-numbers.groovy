Number.metaClass.isHappy = {
    def number = delegate as Long
    def cycle = new HashSet<Long>()
    while (number != 1 && !cycle.contains(number)) {
        cycle << number
        number = (number as String).collect { d = (it as Long); d * d }.sum()
    }
    number == 1
}

def matches = []
for (int i = 0; matches.size() < 8; i++) {
    if (i.happy) { matches << i }
}
println matches
