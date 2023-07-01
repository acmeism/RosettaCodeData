def gcdI = { m, n -> m = m.abs(); n = n.abs(); n == 0 ? m : { while(m%n != 0) { t=n; n=m%n; m=t }; n }() }
