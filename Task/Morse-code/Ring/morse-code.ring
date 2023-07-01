 morsecode = [["a", ".-"],
                      ["b", "-..."],
                      ["c", "-.-."],
                      ["d", "-.."],
                      ["e", "."],
                      ["f", "..-."],
                      ["g", "--."],
                      ["h", "...."],
                      ["i", ".."],
                      ["j", ".---"],
                      ["k", "-.-"],
                      ["l", ".-.."],
                      ["m", "--"],
                      ["n", "-."],
                      ["o", "---"],
                      ["p", ".--."],
                      ["q", "--.-"],
                      ["r", ".-."],
                      ["s", "..."],
                      ["t", "-"],
                      ["u", "..-"],
                      ["v", "...-"],
                      ["w", ".--"],
                      ["x", "-..-"],
                      ["y", "-.--"],
                      ["z", "--.."],
                      ["0", "-----"],
                      ["1", ".----"],
                      ["2", "..---"],
                      ["3", "...--"],
                      ["4", "....-"],
                      ["5", "....."],
                      ["6", "-...."],
                      ["7", "--..."],
                      ["8", "---.."],
                      ["9", "----."]]
strmorse = ""
str = "this is a test text"
for n = 1 to len(str)
     pos = 0
     for m = 1 to len(morsecode)
          if morsecode[m][1] = str[n]
             pos = m
          ok
     next
     if str[n] = " "
        strmorse = strmorse + " "
     else
        if pos > 0
           strmorse = strmorse + morsecode[pos][2] + "|"
        ok
      ok
next
strmorse = left(strmorse,len(strmorse)-1)
see strmorse + nl
