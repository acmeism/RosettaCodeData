// Version 1.2.41

import javax.sound.sampled.AudioFormat
import javax.sound.sampled.AudioSystem
import kotlin.math.sin
import kotlin.math.PI

fun sineWave(frequency: Int, seconds: Int, sampleRate: Int): ByteArray {
    val samples = seconds * sampleRate
    val result = ByteArray(samples)
    val interval = sampleRate.toDouble() / frequency
    for (i in 0 until samples) {
        val angle = 2.0 * PI * i / interval
        result[i] = (sin(angle) * 127).toByte()
    }
    return result
}

fun main(args: Array<String>) {
    val sampleRate = 44000
    val buffer = sineWave(440, 5, sampleRate)
    val format = AudioFormat(sampleRate.toFloat(), 8, 1, true, true)
    val line = AudioSystem.getSourceDataLine(format)
    with (line) {
        open(format)
        start()
        write(buffer, 0, buffer.size)
        drain()
        close()
    }
}
