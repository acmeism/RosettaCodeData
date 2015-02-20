def phaseReverse = { text, closure -> closure(text.split(/ /)).join(' ')}

def text = 'rosetta code phrase reversal'
println "Original:       $text"
println "Reversed:       ${phaseReverse(text) { it.reverse().collect { it.reverse() } } }"
println "Reversed Words: ${phaseReverse(text) { it.collect { it.reverse() } } }"
println "Reversed Order: ${phaseReverse(text) { it.reverse() } }"
