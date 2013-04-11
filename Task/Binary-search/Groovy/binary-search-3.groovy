def a = [] as Set
def random = new Random()
while (a.size() < 20) { a << random.nextInt(30) }
def source = a.sort()
source[0..-2].eachWithIndex { si, i -> assert si < source[i+1] }

println "${source}"
1.upto(5) {
    target = random.nextInt(10) + (it - 2) * 10
    print "Trial #${it}. Looking for: ${target}"
    def answers = [binSearchR, binSearchI].collect { search ->
        search(source, target)
    }
    assert answers[0] == answers[1]
    println """
    Answer: ${answers[0]}, : ${source[answers[0].values().iterator().next()]}"""
}
