def i2 = identity(2)
def i15 = identity(15)


i2.each { print "["; it.each { elt -> printf "%4.1f ", elt }; println "]" }
println()
i15.each { print "["; it.each { elt -> printf "%4.1f ", elt }; println "]" }
