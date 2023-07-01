using SpeechLib;

namespace Speaking_Computer
{
  public class Program
  {
    private static void Main()
    {
      var voice = new SpVoice();
      voice.Speak("This is an example of speech synthesis.");
    }
  }
}
