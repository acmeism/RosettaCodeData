println "Choose out of 5 (one-based):"
(0..3).each { i -> println "Choose ${i}:"; comb1(i, 5).each { println it }; println() }
