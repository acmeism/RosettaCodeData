import java.util.StringTokenizer

object WordWrap extends App {
  final val defaultLineWidth = 80
  final val spaceWidth = 1

  def letsWrap(text: String, lineWidth: Int = defaultLineWidth) = {
    println(s"\n\nWrapped at: $lineWidth")
    println("." * lineWidth)
    minNumLinesWrap(ewd, lineWidth)
  }

  final def ewd = "Vijftig jaar geleden publiceerde Edsger Dijkstra zijn kortstepadalgoritme. Daarom een kleine ode" +
    " aan de in 2002 overleden Dijkstra, iemand waar we als Nederlanders best wat trotser op mogen zijn. Dijkstra was" +
    " een van de eerste programmeurs van Nederland. Toen hij in 1957 trouwde, werd het beroep computerprogrammeur door" +
    " de burgerlijke stand nog niet erkend en uiteindelijk gaf hij maar `theoretische natuurkundige’ op.\nZijn" +
    " beroemdste resultaat is het kortstepadalgoritme, dat de kortste verbinding vindt tussen twee knopen in een graaf" +
    " (een verzameling punten waarvan sommigen verbonden zijn). Denk bijvoorbeeld aan het vinden van de kortste route" +
    " tussen twee steden. Het slimme van Dijkstra’s algoritme is dat het niet alle mogelijke routes met elkaar" +
    " vergelijkt, maar dat het stap voor stap de kortst mogelijke afstanden tot elk punt opbouwt. In de eerste stap" +
    " kijk je naar alle punten die vanaf het beginpunt te bereiken zijn en markeer je al die punten met de afstand tot" +
    " het beginpunt. Daarna kijk je steeds vanaf het punt dat op dat moment de kortste afstand heeft tot het beginpunt" +
    " naar alle punten die je vanaf daar kunt bereiken. Als je een buurpunt via een nieuwe verbinding op een snellere" +
    " manier kunt bereiken, schrijf je de nieuwe, kortere afstand tot het beginpunt bij zo’n punt. Zo ga je steeds een" +
    " stukje verder tot je alle punten hebt gehad en je de kortste route tot het eindpunt hebt gevonden."

  def minNumLinesWrap(text: String, LineWidth: Int) {
    val tokenizer = new StringTokenizer(text)
    var SpaceLeft = LineWidth
    while (tokenizer.hasMoreTokens) {
      val word: String = tokenizer.nextToken
      if ((word.length + spaceWidth) > SpaceLeft) {
        print("\n" + word + " ")
        SpaceLeft = LineWidth - word.length
      } else {
        print(word + " ")
        SpaceLeft -= (word.length + spaceWidth)
      }
    }
  }

  letsWrap(ewd)
  letsWrap(ewd, 120)
} // 44 lines
