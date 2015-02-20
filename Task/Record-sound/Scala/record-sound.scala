import java.io.{File, IOException}
import javax.sound.sampled.{AudioFileFormat, AudioFormat, AudioInputStream}
import javax.sound.sampled.{AudioSystem, DataLine, LineUnavailableException, TargetDataLine}

object SoundRecorder extends App {
  // record duration, in milliseconds
  final val RECORD_TIME = 60000 // 1 minute

  // path and format of the wav file
  val (wavFile, fileType) = (new File("RecordAudio.wav"), AudioFileFormat.Type.WAVE)
  val format = new AudioFormat(/*sampleRate =*/ 16000f,
    /*sampleSizeInBits =*/ 16,
    /*channels =*/ 2,
    /*signed =*/ true,
    /*bigEndian =*/ true)

  val info = new DataLine.Info(classOf[TargetDataLine], format)
  val line: TargetDataLine = AudioSystem.getLine(info).asInstanceOf[TargetDataLine]

  // Entry to run the program

  // Creates a new thread that waits for a specified of time before stopping
  new Thread(new Runnable() {
    def run() {
      try {
        Thread.sleep(RECORD_TIME)
      } catch {
        case ex: InterruptedException => ex.printStackTrace()
      }
      finally {
        line.stop()
        line.close()
      }
      println("Finished")
    }
  }).start()

  //Captures the sound and record into a WAV file
  try {
    // checks if system supports the data line
    if (AudioSystem.isLineSupported(info)) {
      line.open(format)
      line.start() // start capturing
      println("Recording started")
      AudioSystem.write(new AudioInputStream(line), fileType, wavFile)
    } else println("Line not supported")
  } catch {
    case ex: LineUnavailableException => ex.printStackTrace()
    case ioe: IOException => ioe.printStackTrace()
  }
}
