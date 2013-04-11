import scala.util.matching.Regex.MatchIterator

object ScriptName {
	val program = {
		val filenames = new RuntimeException("").getStackTrace.map { t => t.getFileName }
		val scala = filenames.indexOf("NativeMethodAccessorImpl.java")
		
		if (scala == -1)
			"<console>"
		else
			filenames(scala - 1)
	}

	def main(args: Array[String]) {
		val prog = program
		println("Program: " + prog)
	}
}
