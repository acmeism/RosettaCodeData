// version 1.1.3

import java.io.File
import javax.sound.sampled.*

const val RECORD_TIME = 20000L // twenty seconds say

fun main(args: Array<String>) {
    val wavFile = File("RecordAudio.wav")
    val fileType = AudioFileFormat.Type.WAVE
    val format = AudioFormat(16000.0f, 16, 2, true, true)
    val info = DataLine.Info(TargetDataLine::class.java, format)
    val line = AudioSystem.getLine(info) as TargetDataLine

    // Creates a new thread that waits for 'RECORD_TIME' before stopping
    Thread(object: Runnable {
        override fun run() {
            try {
                Thread.sleep(RECORD_TIME)
            }
            catch (ie: InterruptedException) {
                println(ie.message)
            }
            finally {
                line.stop()
                line.close()
            }
            println("Finished")
         }
    }).start()

    // Captures the sound and saves it in a WAV file
    try {
        if (AudioSystem.isLineSupported(info)) {
            line.open(format)
            line.start()
            println("Recording started")
            AudioSystem.write(AudioInputStream(line), fileType, wavFile)
        }
        else println("Line not supported")
    }
    catch (lue: LineUnavailableException) {
        println(lue.message)
    }
}
