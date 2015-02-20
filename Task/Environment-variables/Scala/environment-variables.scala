object Environment_variables extends App {

  def variablesToUse = Seq("USERPROFILE", "java.library.path", "PATH", "HOME", "HOMEPATH", "USERNAME")
  println(sys.env.filter(p => variablesToUse contains p._1).toMap.mkString("\n"))
  println
  println (System.getProperty("java.library.path").split(";").mkString("\n"))

}
