pragma.enable("accumulator")

def left(width, word) {
  return word + " " * (width - word.size())
}

def center(width, word) {
  def leftCount := (width - word.size()) // 2
  return " " * leftCount + word + " " * (width - word.size() - leftCount)
}

def right(width, word) {
  return " " * (width - word.size()) + word
}

def alignColumns(align, text) {
    def split := accum [] for line in text.split("\n") { _.with(line.split("$")) }
    var widths := []
    for line in split {
      for i => word in line {
        widths with= (i, widths.fetch(i, fn{0}).max(word.size()))
      }
    }
    return accum "" for line in split {
      _ + accum "" for i => word in line {
        _ + align(widths[i] + 1, word)
      } + "\n"
    }
}
