for { i <- 1 to 100
      r = 1 to 100 map (i % _ == 0) reduceLeft (_^_)
    } println (i +" "+ (if (r) "open" else "closed"))
