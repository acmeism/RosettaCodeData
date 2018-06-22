import scala.util.Try

object Menu extends App {
  val choice = menu(list)

  def menu(menuList: Seq[String]): String = {
    if (menuList.isEmpty) "" else {
      val n = menuList.size

      def getChoice: Try[Int] = {
        println("\n   M E N U\n")
        menuList.zipWithIndex.map { case (text, index) => s"${index + 1}: $text" }.foreach(println(_))
        print(s"\nEnter your choice 1 - $n : ")
        Try {
          io.StdIn.readInt()
        }
      }

      menuList(Iterator.continually(getChoice)
        .dropWhile(p => p.isFailure || !(1 to n).contains(p.get))
        .next.get - 1)
    }
  }

  def list = Seq("fee fie", "huff and puff", "mirror mirror", "tick tock")

  println(s"\nYou chose : $choice")
}
