object RegisterWinLogEvent extends App {

  import sys.process._

  def eventCreate= Seq("EVENTCREATE", "/T", "SUCCESS", "/id", "123", "/l", "APPLICATION", "/so", "Scala RegisterWinLogEvent", "/d", "Rosetta Code Example"  ).!!

  println(eventCreate)

  println(s"\nSuccessfully completed without errors. [total ${scala.compat.Platform.currentTime - executionStart} ms]")

}
