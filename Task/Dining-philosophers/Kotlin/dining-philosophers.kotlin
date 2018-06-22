// Version 1.2.31

import java.util.Random
import java.util.concurrent.locks.Lock
import java.util.concurrent.locks.ReentrantLock

val rand = Random()

class Fork(val name: String) {
    val lock = ReentrantLock()

    fun pickUp(philosopher: String) {
        lock.lock()
        println("  $philosopher picked up $name")
    }

    fun putDown(philosopher: String) {
        lock.unlock()
        println("  $philosopher put down $name")
    }
}

class Philosopher(val pname: String, val f1: Fork, val f2: Fork) : Thread() {
    override fun run() {
        (1..20).forEach {
            println("$pname is hungry")
            f1.pickUp(pname)
            f2.pickUp(pname)
            println("$pname is eating bite $it")
            Thread.sleep(rand.nextInt(300) + 100L)
            f2.putDown(pname)
            f1.putDown(pname)
        }
    }
}

fun diningPhilosophers(names: List<String>) {
    val size = names.size
    val forks = List(size) { Fork("Fork ${it + 1}") }
    val philosophers = mutableListOf<Philosopher>()
    names.forEachIndexed { i, n ->
        var i1 = i
        var i2 = (i + 1) % size
        if (i2 < i1) {
            i1 = i2
            i2 = i
        }
        val p = Philosopher(n, forks[i1], forks[i2])
        p.start()
        philosophers.add(p)
    }
    philosophers.forEach { it.join() }
}

fun main(args: Array<String>) {
    val names = listOf("Aristotle", "Kant", "Spinoza", "Marx", "Russell")
    diningPhilosophers(names)
}
