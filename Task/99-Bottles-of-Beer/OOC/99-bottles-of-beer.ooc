sing_line: func (b: Int, suffix: Bool) {
  "#{b > 0 ? "#{b}" : "No more"} bottle#{b == 1 ? "" : "s"}" print()
  " of beer#{suffix ? " on the wall" : ""}" println()
}

sing_verse: func (b: Int) {
  println()
  sing_line(b, true)
  sing_line(b, false)
  if (b > 0) {
    "Take one down, pass it around" println()
  } else {
    "Go to the store and buy some more" println()
    b += 100
  }
  sing_line(b-1, true)
}

main: func {
  b := 100
  while (b > 0) {
    sing_verse(--b)
  }
}
