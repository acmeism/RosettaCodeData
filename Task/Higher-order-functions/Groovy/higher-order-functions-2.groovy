def first(func) { func() }
def second() { println "second" }

first(this.&second)
