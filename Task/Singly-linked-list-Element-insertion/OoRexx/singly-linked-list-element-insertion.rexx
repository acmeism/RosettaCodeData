list = .list~new
index = list~insert("abc")   -- insert a first item, keeping the index
Call show
list~insert("def")           -- adds to the end
Call show
list~insert("123", .nil)     -- adds to the begining
Call show
list~insert("456", index)    -- inserts between "abc" and "def"
Call show
list~remove(index)           -- removes "abc"
Call show
exit
show:
s=''
Do x over list
  s=s x
  end
say s
Return
