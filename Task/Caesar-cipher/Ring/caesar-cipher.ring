# Project : Caesar cipher
# Date    : 2017/11/11
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

cipher = "pack my box with five dozen liquor jugs"
abc = "abcdefghijklmnopqrstuvwxyz"
see "text is to be encrypted:" + nl
see cipher+ nl + nl
str = ""
key = random(24) + 1
see "key = " + key + nl + nl
see "encrypted:" + nl
caesarencode(cipher, key)
see str + nl + nl
cipher = str
see "decrypted again:" + nl
caesardecode(cipher, key)
see str + nl

func caesarencode(cipher, key)
       str = ""
       for n = 1 to len(cipher)
            if cipher[n] != " "
               pos = substr(abc, cipher[n])
               if pos + key < len(abc)
                  str = str + abc[pos + key]
               else
                  if (pos+key)-len(abc) != 0
                     str = str + abc[(pos+key)%len(abc)]
                  else
                      str = str +abc[key+pos]
                  ok
                    ok
               else
                  str = str + " "
               ok
       next
     return str

func caesardecode(cipher, key)
       str = ""
       for n= 1 to len(cipher)
            if cipher[n] != " "
               pos = substr(abc, cipher[n])
               if (pos - key) > 0 and pos != key
                   str = str + abc[pos - key]
                   loop
               else
                   if pos = key
                      str = str + char(122)
                   else
                     str = str + abc[len(abc)-(key-pos)]
                   ok
               ok
            else
               str = str + " "
            ok
       next
       return str
