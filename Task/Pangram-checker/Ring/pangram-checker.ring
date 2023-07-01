pangram = 0
s = "The quick brown fox jumps over the lazy dog."
see "" + pangram(s) + " " + s + nl

s = "My dog has fleas."
see "" + pangram(s) + " " + s + nl

func pangram str
     str  = lower(str)
     for i = ascii("a") to ascii("z")
             bool = substr(str, char(i)) > 0
             pangram = pangram + bool
     next
     pan = (pangram = 26)
     return pan
