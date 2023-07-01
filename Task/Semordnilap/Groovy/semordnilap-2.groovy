def semordnilaps = semordnilapWords(new URL('http://www.puzzlers.org/pub/wordlists/unixdict.txt'))
println "Found ${semordnilaps.size()} semordnilap words"
semordnilaps[0..<5].each { println "$it -> ${it.reverse()}" }
