# Project : Input/Output for Lines of Text

see "n = "
give n
lines = list(number(n))
for i = 1 to  n
    see "lines[" + i + "] = " + nl
    give lines[i]
next
see nl
printlines(lines)

func printlines(lines)
     for i = 1 to len(lines)
         see lines[i] + nl
     next
