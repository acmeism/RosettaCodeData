def aa = [ 1, 25, 31, -3 ]           // list
def a = [0] * 100                    // list of 100 zeroes
def b = 1..9                         // range notation
def c = (1..10).collect { 2.0**it }  // each output element is 2**(corresponding invoking list element)

// There are no true "multi-dimensional" arrays in Groovy (as in most C-derived languages).
// Use lists of lists in natural ("row major") order as a stand in.
def d = (0..1).collect { i -> (1..5).collect { j -> 2**(5*i+j) as double } }
def e = [ [  1.0,  2.0,  3.0,  4.0 ],
          [  5.0,  6.0,  7.0,  8.0 ],
          [  9.0, 10.0, 11.0, 12.0 ],
          [ 13.0, 14.0, 15.0, 16.0 ] ]

println aa
println b
println c
println()
d.each { print "["; it.each { elt -> printf "%7.1f ", elt }; println "]" }
println()
e.each { print "["; it.each { elt -> printf "%7.1f ", elt }; println "]" }
