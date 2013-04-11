println "Choose out of 5 (zero-based):"
(0..3).each { i -> println "Choose ${i}:"; comb0(i, 5).each { println it }; println() }
