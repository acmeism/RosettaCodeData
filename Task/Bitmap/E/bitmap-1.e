def makeFlexList := <elib:tables.makeFlexList>
def format := <import:java.lang.makeString>.format

def CHANNELS := 3
def UByte := 0..255

def makeColor {
  to fromFloat(r, g, b) {
    return makeColor.fromByte((r * 255).round(),
                              (g * 255).round(),
                              (b * 255).round())
  }
  to fromByte(r :UByte, g :UByte, b :UByte) {
    def color {
      to __printOn(out) {
        out.print(format("%02x%02x%02x", [color.rb(), color.gb(), color.bb()]))
      }
      to rf() { return r / 255 }
      to gf() { return g / 255 }
      to bf() { return b / 255 }
      to rb() { return r }
      to gb() { return g }
      to bb() { return b }
    }
    return color
  }
}

/** Convert 0..255 into 0..127 -128..-1 */
def sign(v) {
  return v %% 256 - 2*(v & 128)
}

def makeImage(width, height) {
  # NOTE: The primary E implementation is in Java and Java's fixed-size integers only
  # come in signed varieties. Therefore, there is a little bit of extra arithmetic.
  #
  # In an ideal E implementation we would specify the type 0..255, but this is not
  # currently possible everywhere, or efficient.

  def storage := makeFlexList.fromType(<type:java.lang.Byte>, width * height * CHANNELS)
  storage.setSize(width * height * CHANNELS)

  def X := 0..!width
  def Y := 0..!height

  def flexImage {
    to __printOn(out) {
      for y in Y {
        out.print("[")
        for x in X {
          out.print(flexImage[x, y], " ")
        }
        out.println("]")
      }
    }
    to width() { return width }
    to height() { return height }
    to fill(color) {
      for x in X {
        for y in Y {
          flexImage[x, y] := color
        }
      }
    }
    to get(x :X, y :Y) {
      def base := (y * width + x) * CHANNELS
      return makeColor.fromByte(storage[base + 0] %% 256,
                                storage[base + 1] %% 256,
                                storage[base + 2] %% 256)
    }
    /** Provided to make [[Flood fill]] slightly less insanely slow. */
    to test(x :X, y :Y, c) {
      def base := (y * width + x) * CHANNELS
      return storage[base + 0] <=> sign(c.rb()) &&
             storage[base + 1] <=> sign(c.gb()) &&
             storage[base + 2] <=> sign(c.bb())
    }
    to put(x :X, y :Y, c) {
      def base := (y * width + x) * CHANNELS
      storage[base + 0] := sign(c.rb())
      storage[base + 1] := sign(c.gb())
      storage[base + 2] := sign(c.bb())
    }
    to writePPM(outputStream) {
      outputStream.write(`P6$\n$width $height$\n255$\n`.getBytes("US-ASCII"))
      outputStream.write(storage.getArray())
    }
    /** Used for [[Read ppm file]] */
    to replace(list :List) {
      require(list.size() == width * height * CHANNELS)
      storage(0) := list
    }
  }

  return flexImage
}
