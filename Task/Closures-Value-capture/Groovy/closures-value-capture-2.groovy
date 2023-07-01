assert closures instanceof List
assert closures.size() == 10
closures.each { assert it instanceof Closure }
println closures[7]()
