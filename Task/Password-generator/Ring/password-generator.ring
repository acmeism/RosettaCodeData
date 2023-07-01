# Project : Password generator

chars = list(4)
strp = list(2)
password = ""
chars[1] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
chars[2] = "abcdefghijklmnopqrstuvwxyz"
chars[3] = "0123456789"
chars[4] = "!\#$%&'()*+,-./:;<=>?@[]^_{|}~"

init()
plen = number(strp[1])

for n = 1 to strp[2]
     passwords(chars)
     see "password = " + password + nl
next

func passwords(chars)
       index = 0
       password = ""
       while index < plen
                 index = index + 1
                 charsind1 = index % len(chars) + 1
                 charsind2 = random(len(chars[charsind1])-1) + 1
                 password = password + chars[charsind1][charsind2]
       end

func init()
       fp = fopen("C:\Ring\calmosoft\pwgen.ring","r")
       r = ""
       str = ""
       nr = 0
       while isstring(r)
               r = fgetc(fp)
               if r != char(10) and not feof(fp)
                  str = str + r
                  nr = nr + 1
                  strp[nr] = str
               else
                  str = ""
               ok
       end
       fclose(fp)
