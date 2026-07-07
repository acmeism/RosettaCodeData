metronome <- function(bpm = 72, bpb = 4) {
  slp <- 60 / bpm
  counter <- 0
  repeat {
    counter <- counter + 1
    cat(ifelse(counter %% bpb, "tick", "TICK"), "")
    Sys.sleep(slp)
  }
}

metronome()
