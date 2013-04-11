doors = [false] * 100
(0..99).each {
   it.step(100, it + 1) {
      doors[it] ^= true
   }
}
(0..99).each {
   println("Door #${it + 1} is ${doors[it] ? 'open' : 'closed'}.")
}
