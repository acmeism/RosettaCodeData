def join(a, b) {
  # This must not use the builtin if, since it coerces to boolean rather than passing messages.
  # false.pick(x, y) returns y and true.pick(x, y) returns x; we protect the amb([]) from causing
  # unconditional failure by putting both options in functions.
  # <=> is the comparison operator that happens to be message-based.
  return (a.last() <=> b[0]).pick(fn {
    a + " " + b
  }, fn {
    amb([])
  })()
}

def w1 := amb(["the", "that", "a"           ])
def w2 := amb(["frog", "elephant", "thing"  ])
def w3 := amb(["walked", "treaded", "grows" ])
def w4 := amb(["slowly", "quickly"          ])

unamb(join(join(join(w1, w2), w3), w4))
