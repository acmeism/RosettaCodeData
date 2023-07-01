{
  println("Read")
  def i := readPPM(<import:java.io.makeFileInputStream>(<file:Unfilledcirc.ppm>))
  println("Fill 1")
  floodFill(i, 100, 100, makeColor.fromFloat(1, 0, 0))
  println("Fill 2")
  floodFill(i, 200, 200, makeColor.fromFloat(0, 1, 0))
  println("Write")
  i.writePPM(<import:java.io.makeFileOutputStream>(<file:Filledcirc.ppm>))
  println("Done")
}
