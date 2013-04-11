def c1 = new Concrete1()
assert c1 instanceof Interface
println (new Concrete1().method2("Superman"))

def c2 = new Concrete2()
assert c2 instanceof Abstract1
println (new Concrete2().methodB("Spiderman"))

def c3 = new Concrete3()
assert c3 instanceof Interface
assert c3 instanceof Abstract2
println (new Concrete3().method2("Hellboy"))
