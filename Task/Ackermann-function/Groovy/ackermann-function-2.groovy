def ackMatrix = (0..3).collect { m -> (0..8).collect { n -> ack(m, n) } }
ackMatrix.each { it.each { elt -> printf "%7d", elt }; println() }
