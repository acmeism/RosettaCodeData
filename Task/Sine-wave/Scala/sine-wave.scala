import javax.sound.sampled.{AudioFormat, AudioSystem, SourceDataLine}

import scala.math.{Pi, sin}

object SineWave extends App {
  val sampleRate = 44000
  val buffer = beep(440, 5, sampleRate)
  val line: SourceDataLine = AudioSystem.getSourceDataLine(format)

  def format = new AudioFormat(sampleRate.toFloat, 8, 1, true, false)

  def beep(frequency: Int, seconds: Int, sampleRate: Int) = {
    val samples = seconds * sampleRate
    val interval = sampleRate / frequency
    val angle = 2.0 * Pi  / interval
    (0 until samples).map(i => (sin(angle * i) * 127).toByte).toArray
  }

  line.open()
  line.start()
  line.write(buffer, 0, buffer.length)
  line.drain()
  line.close()

}
