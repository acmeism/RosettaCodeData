# Project : Nested function

makeList(". ")
func makeitem(sep, counter, text)
       see "" + counter + sep + text + nl

func makelist(sep)
       a = ["first", "second", "third"]
       counter = 0
       while counter < 3
                counter = counter + 1
                makeitem(sep, counter, a[counter])
       end
