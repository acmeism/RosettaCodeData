def cells = ('_###_##_#_#_#_#__#__' as List).collect { it == '#' }
println "Generation 0: ${cells.collect { g -> g ? '#' : '_' }.join()}"
(1..9).each {
    cells = life1D(cells)
    println "Generation ${it}: ${cells.collect { g -> g ? '#' : '_' }.join()}"
}
