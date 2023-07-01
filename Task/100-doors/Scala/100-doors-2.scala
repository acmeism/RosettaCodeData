def openDoors(length : Int = 100) = {
    var isDoorOpen = new Array[Boolean](length)

    for (i <- 0 until length) {
        for (j <- i until length by i + 1) {
            isDoorOpen(j) ^= true
        }
    }
    isDoorOpen
}

val doorState  = scala.collection.immutable.Map(false -> "closed", true -> "open")
val isDoorOpen = openDoors()

for (doorNo <- 0 until isDoorOpen.length) {
    println("Door %d is %s".format(doorNo + 1, doorState(isDoorOpen(doorNo))))
}
