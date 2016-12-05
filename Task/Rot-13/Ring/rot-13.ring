see "enter a string : " give s
ans = ""
for a = 1 to len(s)
    letter = substr(s, a, 1)
    if letter >= "a" and letter <= "z"
       char = char(ascii(letter) + 13)
       if char > "z" char = chr(asc(char) - 26) ok
    else
       if letter >= "a" and letter <= "z" char = char(ascii(letter) + 13) ok
       if char > "z" char = char(ascii(char) - 26) else  char = letter ok
    ok
    ans = ans + char
nex
see ans + nl
