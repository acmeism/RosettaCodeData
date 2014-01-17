import java.util.Locale
import javax.speech.Central
import javax.speech.synthesis.{ Synthesizer, SynthesizerModeDesc }

object ScalaSpeaker extends App {

  def speech(text: String) = {
    if (!text.trim.isEmpty()) {
      val voiceName = "kevin16"

      System.setProperty("freetts.voices", "com.sun.speech.freetts.en.us.cmu_us_kal.KevinVoiceDirectory")
      try {
        Central.registerEngineCentral("com.sun.speech.freetts.jsapi.FreeTTSEngineCentral")

        val synth =
          Central.createSynthesizer(new SynthesizerModeDesc(Locale.US))
        synth.allocate()

        val desc = synth.getEngineModeDesc() match {
          case g2: SynthesizerModeDesc => g2
          case _                       => throw new ClassCastException
        }

        synth.getSynthesizerProperties()
          .setVoice(desc.getVoices().find(_.toString() == voiceName).get)
        //synth.resume()
        synth.speakPlainText(text, null)
        synth.waitEngineState(Synthesizer.QUEUE_EMPTY)
        synth.deallocate()
      } catch {
        case ex: Throwable => ex.printStackTrace()
      }
    }
  }

  speech("If it ain't Dutch, It ain't much.")
}
