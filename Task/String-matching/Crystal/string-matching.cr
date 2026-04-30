p "banana".starts_with? "ba"   #=> true
p "banana".starts_with? "na"   #=> false

p "banana".includes? "an"      #=> true
p "banana".includes? "xa"      #=> false

p "banana".ends_with? "na"     #=> true
p "banana".ends_with? "ba"     #=> false

p "banana".index "na"          #=> 2
p "banana".index "na", 3       #=> 4
p "banana".index "na", 5       #=> nil
