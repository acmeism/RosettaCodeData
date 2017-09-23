   a = .array~new       -- create a zero element array
   b = .array~new(10)   -- create an array with initial size of 10
   c = .array~of(1, 2, 3)  -- creates a 3 element array holding objects 1, 2, and 3
   a[3] = "Fred"        -- assign an item
   b[2] = a[3]          -- retrieve an item from the array
   c~append(4)          -- adds to end.  c[4] == 4 now
