object ListMethods extends App {

  private val obj = new {
    def examplePublicInstanceMethod(c: Char, d: Double) = 42

    private def examplePrivateInstanceMethod(s: String) = true
  }
  private val clazz = obj.getClass

  println("All public methods (including inherited):")
  clazz.getMethods.foreach(m => println(s"${m}"))

  println("\nAll declared fields (excluding inherited):")
  clazz.getDeclaredMethods.foreach(m => println(s"${m}}"))

}
