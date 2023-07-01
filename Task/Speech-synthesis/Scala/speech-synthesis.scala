import javax.speech.Central
import javax.speech.synthesis.{Synthesizer, SynthesizerModeDesc}

object ScalaSpeaker extends App {

  def speech(text: String) = {
    if (!text.trim.isEmpty) {
      val VOICENAME = "kevin16"

      System.setProperty("freetts.voices", "com.sun.speech.freetts.en.us.cmu_us_kal.KevinVoiceDirectory")
      Central.registerEngineCentral("com.sun.speech.freetts.jsapi.FreeTTSEngineCentral")

      val synth = Central.createSynthesizer(null)
      synth.allocate()

      val desc = synth.getEngineModeDesc match {case g2: SynthesizerModeDesc => g2}

      synth.getSynthesizerProperties.setVoice(desc.getVoices.find(_.toString == VOICENAME).get)
      synth.speakPlainText(text, null)

      synth.waitEngineState(Synthesizer.QUEUE_EMPTY)
      synth.deallocate()
    }
  }

  speech( """Thinking of Holland
            |I see broad rivers
            |slowly chuntering
            |through endless lowlands,
            |rows of implausibly
            |airy poplars
            |standing like tall plumes
            |against the horizon;
            |and sunk in the unbounded
            |vastness of space
            |homesteads and boweries
            |dotted across the land,
            |copses, villages,
            |couchant towers,
            |churches and elm-trees,
            |bound in one great unity.
            |There the sky hangs low,
            |and steadily the sun
            |is smothered in a greyly
            |iridescent smirr,
            |and in every province
            |the voice of water
            |with its lapping disasters
            |is feared and hearkened.""".stripMargin)
}
