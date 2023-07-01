object ListProperties extends App {
  private val obj = new {
    val examplePublicField: Int = 42
    private val examplePrivateField: Boolean = true
  }
  private val clazz = obj.getClass

  println("All public methods (including inherited):")
  clazz.getFields.foreach(f => println(s"${f}\t${f.get(obj)}"))

  println("\nAll declared fields (excluding inherited):")
  clazz.getDeclaredFields.foreach(f => println(s"${f}}"))
}
