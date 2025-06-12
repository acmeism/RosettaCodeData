proc modes &in[] &r[] .
   r[] = [ ]
   for v in in[]
      for i to len vals[]
         if v = vals[i]
            cnt[i] += 1
            max = higher cnt[i] max
            break 1
         .
      .
      vals[] &= v
      cnt[] &= 0
   .
   for i to len cnt[]
      if cnt[i] = max : r[] &= vals[i]
   .
.
in[] = [ 1 3 6 6 6 6 7 7 12 12 17 ]
modes in[] mods[]
print mods[]
in[] = [ 1 1 2 4 4 ]
modes in[] mods[]
print mods[]
