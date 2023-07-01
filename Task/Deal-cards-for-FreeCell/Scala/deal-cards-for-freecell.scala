object Shuffler extends App {

  private val suits = Array("C", "D", "H", "S")
  private val values = Array("A", "2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K")
  private val deck = values.flatMap(v => suits.map(s => s"$v$s"))

  private var seed: Int = _

  private def random() = {
    seed = (214013 * seed + 2531011) & Integer.MAX_VALUE
    seed >> 16
  }

  private def getShuffledDeck = {
    val d = deck.map(c => c)
    for(i <- deck.length - 1 until 0 by -1) {
      val r = random() % (i + 1)
      val card = d(r)
      d(r) = d(i)
      d(i) = card
    }
    d.reverse
  }

  def deal(seed: Int): Unit = {
    this.seed = seed
    getShuffledDeck.grouped(8).foreach(e => println(e.mkString(" ")))
  }

  deal(1)
  println
  deal(617)
}
