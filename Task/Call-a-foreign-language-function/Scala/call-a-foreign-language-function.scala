object JNIDemo {
  try System.loadLibrary("JNIDemo")

  private def callStrdup(s: String)

  println(callStrdup("Hello World!"))
}
