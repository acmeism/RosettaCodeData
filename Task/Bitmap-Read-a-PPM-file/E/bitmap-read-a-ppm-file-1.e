def chr := <import:java.lang.makeCharacter>.asChar

def readPPM(inputStream) {
  # Proper native-to-E stream IO facilities have not been designed and
  # implemented yet, so we are borrowing Java's. Poorly. This *will* be
  # improved eventually.

  # Reads one header token, skipping comments and whitespace, and exactly
  # one trailing whitespace character
  def readToken() {
    var token := ""
    var c := chr(inputStream.read())
    while (c == ' ' || c == '\t' || c == '\r' || c == '\n' || c == '#') {
      if (c == '#') {
        while (c != '\n') { c := chr(inputStream.read()) }
      }
      # skip over initial whitespace
      c := chr(inputStream.read())
    }
    while (!(c == ' ' || c == '\t' || c == '\r' || c == '\n')) {
      if (c == '#') {
        while (c != '\n') { c := chr(inputStream.read()) }
      } else {
        token += E.toString(c)
        c := chr(inputStream.read())
      }
    }
    return token
  }

  # Header
  require(readToken() == "P6")
  def width := __makeInt(readToken())
  def height := __makeInt(readToken())
  def maxval := __makeInt(readToken())

  def size := width * height * 3

  # Body
  # See [[Basic bitmap storage]] for the definition and origin of sign()
  def data := <elib:tables.makeFlexList>.fromType(<type:java.lang.Byte>, size)
  if (maxval >= 256) {
    for _ in 1..size {
      data.push(sign((inputStream.read() * 256 + inputStream.read()) * 255 // maxval))
    }
  } else {
    for _ in 1..size {
      data.push(sign(inputStream.read() * 255 // maxval))
    }
  }

  def image := makeImage(width, height)
  image.replace(data.snapshot())
  return image
}
