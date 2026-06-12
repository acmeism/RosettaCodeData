import java.util.concurrent.ConcurrentHashMap
import kotlin.concurrent.thread

class MainKt {
    companion object {
        private val dict = ConcurrentHashMap<Int, Int>()
        private var criticalValue = 1
        private val lockObject = Any()

        @JvmStatic
        fun main(args: Array<String>) {
            testSzymanski(20)
        }

        private fun flag(id: Int): Int {
            return dict.computeIfAbsent(id) { 0 }
        }

        private fun runSzymanski(id: Int, allszy: IntArray) {
            val others = allszy.filter { it != id }.toIntArray()

            dict[id] = 1 // Standing outside waiting room

            while (others.any { flag(it) >= 3 }) {
                Thread.yield()
            }

            dict[id] = 3 // Standing in doorway

            if (others.any { flag(it) == 1 }) {
                dict[id] = 2 // Waiting for other processes to enter
                while (!others.any { flag(it) == 4 }) {
                    Thread.yield()
                }
            }

            dict[id] = 4 // The door is closed

            for (t in others) {
                if (t >= id) continue
                while (flag(t) > 1) {
                    Thread.yield()
                }
            }

            // Critical section
            synchronized(lockObject) {
                criticalValue += id * 3
                criticalValue /= 2
                println("Thread $id changed the critical value to $criticalValue.")
            }
            // End critical section

            // Exit protocol
            for (t in others) {
                if (t <= id) continue
                while (flag(t) !in listOf(0, 1, 4)) {
                    Thread.yield()
                }
            }

            dict[id] = 0 // Leave. Reopen door if nobody is still in the waiting room
        }

        private fun testSzymanski(n: Int) {
            val allszy = IntArray(n) { it + 1 }
            val threads = allszy.map { id ->
                thread(start = false) { runSzymanski(id, allszy) } // Don't start immediately
            }.toTypedArray()

            threads.forEach { it.start() }

            try {
                threads.forEach { it.join() }
            } catch (e: InterruptedException) {
                e.printStackTrace()
            }
        }
    }
}
