l = .list~new       -- lists have no inherent size
index = l~insert('123')  -- adds an item to this list, returning the index
l~insert('Fred', .nil)   -- inserts this at the beginning
l~insert('Mike')         -- adds this to the end
l~insert('Rick', index)  -- inserts this after '123'
l[index] = l[index] + 1  -- the original item is now '124'
do item over l           -- iterate over the items, displaying them in order
  say item
end
