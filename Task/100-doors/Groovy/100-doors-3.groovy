doors = ['closed'] * 100
(1..10).each { doors[it**2 - 1] = 'open' }
(0..99).each {
   println("Door #${it + 1} is ${doors[it]}.")
}
