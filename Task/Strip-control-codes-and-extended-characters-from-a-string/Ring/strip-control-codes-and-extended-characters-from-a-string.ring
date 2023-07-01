s = char(31) + "abc" + char(13) + "def" + char(11) + "ghi" + char(10)
see strip(s) + nl

func strip str
strip = ""
for i = 1 to len(str)
    nr = substr(str,i,1)
    a = ascii(nr)
    if a > 31 and a < 123 and nr != "'" and nr != """"
       strip = strip + nr ok
next
return strip
