proc cyclesort &a[] .
   for cs = 1 to len a[] - 1
      item = a[cs]
      pos = cs
      for i = cs + 1 to len a[]
         if a[i] < item : pos += 1
      .
      if pos <> cs
         while item = a[pos] : pos += 1
         t = a[pos]
         a[pos] = item
         item = t
         while pos <> cs
            pos = cs
            for i = cs + 1 to len a[]
               if a[i] < item : pos += 1
            .
            while item = a[pos] : pos += 1
            t = a[pos]
            a[pos] = item
            item = t
         .
      .
   .
.
d[] = [ 88 18 31 44 4 0 8 81 14 78 20 76 84 33 73 75 82 5 62 70 ]
cyclesort d[]
print d[]
