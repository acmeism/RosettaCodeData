def csny = [ "Crosby", "Stills", "Nash", "Young" ]
println "Choose from ${csny}"
(0..(csny.size())).each { i -> println "Choose ${i}:"; comb(i, csny).each { println it }; println() }
