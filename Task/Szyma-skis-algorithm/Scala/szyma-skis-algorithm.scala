import scala.collection.concurrent.TrieMap
import scala.util.Try

object Program {
  private val dict = TrieMap[Int, Int]()
  private var criticalValue = 1
  private val lockObject = new Object

  def main(args: Array[String]): Unit = {
    testSzymanski(20)
  }

  def flag(id: Int): Int = {
    dict.getOrElseUpdate(id, 0)
  }

  def runSzymanski(id: Int, allszy: Array[Int]): Unit = {
    val others = allszy.filter(_ != id)
    dict.put(id, 1) // Standing outside waiting room

    while (others.exists(t => flag(t) >= 3)) {
      Thread.`yield`()
    }

    dict.put(id, 3) // Standing in doorway
    if (others.exists(t => flag(t) == 1)) {
      dict.put(id, 2) // Waiting for other processes to enter
      while (!others.exists(t => flag(t) == 4)) {
        Thread.`yield`()
      }
    }

    dict.put(id, 4) // The door is closed
    others.filter(_ < id).foreach { t =>
      while (flag(t) > 1) {
        Thread.`yield`()
      }
    }

    // critical section
    lockObject.synchronized {
      criticalValue += id * 3
      criticalValue /= 2
      println(s"Thread $id changed the critical value to $criticalValue.")
    }
    // end critical section

    // Exit protocol
    others.filter(_ > id).foreach { t =>
      while (!Seq(0, 1, 4).contains(flag(t))) {
        Thread.`yield`()
      }
    }
    dict.put(id, 0) // Leave. Reopen door if nobody is still in the waiting room
  }

  def testSzymanski(n: Int): Unit = {
    val allszy = (1 to n).toArray
    val threads = allszy.map { i =>
      new Thread(new Runnable {
        def run(): Unit = runSzymanski(i, allszy)
      })
    }

    threads.foreach(_.start())

    Try {
      threads.foreach(_.join())
    }.recover {
      case e: InterruptedException => e.printStackTrace()
    }
  }
}
