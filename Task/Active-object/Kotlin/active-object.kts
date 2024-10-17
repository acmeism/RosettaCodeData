// version 1.2.0

import kotlin.math.*

typealias Function = (Double) -> Double

/**
 * Integrates input function K over time
 * S + (t1 - t0) * (K(t1) + K(t0)) / 2
 */
class Integrator {
    private val start: Long
    private @Volatile var running = false
    private lateinit var func: Function
    private var t0 = 0.0
    private var v0 = 0.0
    private var sum = 0.0

    constructor(func: Function) {
        start = System.nanoTime()
        setFunc(func)
        Thread(this::integrate).start()
    }

    fun setFunc(func: Function) {
        this.func = func
        v0 = func(0.0)
        t0 = 0.0
    }

    fun getOutput() = sum

    fun stop() {
        running = false
    }

    private fun integrate() {
        running = true
        while (running) {
            try {
                Thread.sleep(1)
                update()
            }
            catch(e: InterruptedException) {
                return
            }
        }
    }

    private fun update() {
        val t1 = (System.nanoTime() - start) / 1.0e9
        val v1 = func(t1)
        val rect = (t1 - t0) * (v0 + v1) / 2.0
        sum  += rect
        t0 = t1
        v0 = v1
    }
}

fun main(args: Array<String>) {
    val integrator = Integrator( { sin(PI * it) } )
    Thread.sleep(2000)

    integrator.setFunc( { 0.0 } )
    Thread.sleep(500)

    integrator.stop()
    println(integrator.getOutput())
}
