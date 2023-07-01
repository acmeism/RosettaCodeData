local bitmap = Bitmap(32,32)

-- default pixel representation is 32-bit packed ARGB on [0,255]
bitmap:clear(0xFFFF0000) -- fill with red
bitmap:set(1, 1, 0xFF00FF00) -- one green pixel
bitmap:set(2, 2, 0xFF0000FF) -- one blue pixel
print(string.format("pixel at 0,0 = %x", bitmap:get(0,0)))
print(string.format("pixel at 1,1 = %x", bitmap:get(1,1)))
print(string.format("pixel at 2,2 = %x", bitmap:get(2,2)))

-- but note that pixel representation is agnostic..
-- (it's just a wrapper around a 2d-array of any valid type)

-- want to switch to RGB-tuple on [0,1]??
bitmap:clear({1,0,0}) -- fill with red
bitmap:set(1, 1, {0,1,0}) -- one green pixel
bitmap:set(2, 2, {0,0,1}) -- one blue pixel
print(string.format("pixel at 0,0 = %s", table.concat(bitmap:get(0,0),", ")))
print(string.format("pixel at 1,1 = %s", table.concat(bitmap:get(1,1),", ")))
print(string.format("pixel at 2,2 = %s", table.concat(bitmap:get(2,2),", ")))

-- or strings??
bitmap:clear("red") -- fill with red
bitmap:set(1, 1, "green") -- one green pixel
bitmap:set(2, 2, "blue") -- one blue pixel
print(string.format("pixel at 0,0 = %s", bitmap:get(0,0)))
print(string.format("pixel at 1,1 = %s", bitmap:get(1,1)))
print(string.format("pixel at 2,2 = %s", bitmap:get(2,2)))
