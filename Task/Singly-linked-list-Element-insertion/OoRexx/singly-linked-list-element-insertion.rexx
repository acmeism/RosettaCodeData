list = .linkedlist~new
index = list~insert("abc")   -- insert a first item, keeping the index
list~insert("def")           -- adds to the end
list~insert("123", .nil)     -- adds to the begining
list~insert("456", index)    -- inserts between "abc" and "def"
list~remove(index)           -- removes "abc"
