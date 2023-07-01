tm = "0"
see tm
for n = 1 to 6
    tm = thue_morse(tm)
    see tm
next

func thue_morse(previous)
     tm = ""
     for i = 1 to len(previous)
         if (substr(previous, i, 1) = "1") tm = tm + "0" else tm  = tm + "1" ok
     next
     see nl
     return (previous + tm)
