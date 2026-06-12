import scala.io.StdIn.readLine

object BankersAlgorithm {
  def main(args: Array[String]): Unit = {
    println("Number of resources: ")
    val resources = readLine().toInt

    println("Number of processes: ")
    val processes = readLine().toInt

    println("Maximum resources: ")
    val maxResources = readLine().split(" ").map(_.toInt)

    println("\n-- resources allocated for each process --")
    val currentlyAllocated = Array.ofDim[Int](processes, resources)
    for (i <- 0 until processes) {
      println(s"process ${i + 1}: ")
      currentlyAllocated(i) = readLine().split(" ").map(_.toInt)
    }

    println("\n--- maximum resources for each process ---")
    val maxNeed = Array.ofDim[Int](processes, resources)
    for (i <- 0 until processes) {
      println(s"process ${i + 1}: ")
      maxNeed(i) = readLine().split(" ").map(_.toInt)
    }

    val allocated = Array.fill(resources)(0)
    for (i <- 0 until processes) {
      for (j <- 0 until resources) {
        allocated(j) += currentlyAllocated(i)(j)
      }
    }
    println(s"\nTotal resources allocated: ${allocated.mkString(", ")}")

    val available = maxResources.zip(allocated).map { case (max, alloc) => max - alloc }
    println(s"Total resources available: ${available.mkString(", ")}\n")

    var running = Array.fill(processes)(true)
    var count = processes

    while (count != 0) {
      var safe = false
      for (i <- 0 until processes if running(i)) {
        var executing = true
        for (j <- 0 until resources) {
          if (maxNeed(i)(j) - currentlyAllocated(i)(j) > available(j)) {
            executing = false
          }
        }
        if (executing) {
          println(s"process ${i + 1} is running")
          running(i) = false
          count -= 1
          safe = true
          for (j <- 0 until resources) {
            available(j) += currentlyAllocated(i)(j)
          }
        }
      }

      if (!safe) {
        println("The processes are in an unsafe state.")
        return
      }

      println(s"The processes are in a safe state.\nAvailable resources: ${available.mkString(", ")}\n")
    }
  }
}
