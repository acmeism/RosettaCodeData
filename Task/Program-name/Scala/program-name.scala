object ScriptName extends App {
  println(s"Program of instantiated object: ${this.getClass.getName}")
  // Not recommended, due various implementations
  println(s"Program via enviroment:         ${System.getProperty("sun.java.command")}")
}
