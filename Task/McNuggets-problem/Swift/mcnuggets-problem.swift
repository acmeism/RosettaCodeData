func maxNugget(limit: Int) -> Int {
  var (max, sixes, nines, twenties, i) = (0, 0, 0, 0, 0)

  mainLoop: while i < limit {
    sixes = 0

    while sixes * 6 < i {
      if sixes * 6 == i {
        i += 1
        continue mainLoop
      }

      nines = 0

      while nines * 9 < i {
        if sixes * 6 + nines * 9 == i {
          i += 1
          continue mainLoop
        }

        twenties = 0

        while twenties * 20 < i {
          if sixes * 6 + nines * 9 + twenties * 20 == i {
            i += 1
            continue mainLoop
          }

          twenties += 1
        }

        nines += 1
      }

      sixes += 1
    }

    max = i
    i += 1
  }

  return max
}

print(maxNugget(limit: 100))
