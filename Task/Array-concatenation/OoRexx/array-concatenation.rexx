a = .array~of(1,2,3)
say "Array a has " a~items "items"
b = .array~of(4,5,6)
say "Array b has " b~items "items"
a~appendall(b)        -- adds all items from b to a
say "Array a now has " a~items "
