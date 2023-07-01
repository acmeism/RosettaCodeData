def gcdR
gcdR = { m, n -> m = m.abs(); n = n.abs(); n == 0 ? m : m%n == 0 ? n : gcdR(n, m%n) }
