a = .array~new(4)   -- creates an array of 4 items, with all slots empty
say a~size a~items  -- size is 4, but there are 0 items
a[1] = "Fred"       -- assigns a value to the first item
a[5] = "Mike"       -- assigns a value to the fifth slot, expanding the size
say a~size a~items  -- size is now 5, with 2 items
