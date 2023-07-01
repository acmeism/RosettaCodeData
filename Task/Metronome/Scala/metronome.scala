def metronome(bpm: Int, bpb: Int, maxBeats: Int = Int.MaxValue) {
  val delay = 60000L / bpm
  var beats = 0
  do {
    Thread.sleep(delay)
    if (beats % bpb == 0) print("\nTICK ")
    else print("tick ")
    beats+=1
  }
  while (beats < maxBeats)
  println()
}

metronome(120, 4, 20) // limit to 20
