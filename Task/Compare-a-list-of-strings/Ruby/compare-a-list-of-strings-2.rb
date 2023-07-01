strings.all?{|str| str == strings.first} # all equal?
strings.each_cons(2).all?{|str1, str2| str1 < str2} # ascending?
