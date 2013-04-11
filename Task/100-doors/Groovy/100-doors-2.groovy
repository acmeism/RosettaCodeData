(1..100).each {
   println("Door #${it} is ${Math.sqrt(it).with{it==(int)it} ? 'open' : 'closed'}.")
}
