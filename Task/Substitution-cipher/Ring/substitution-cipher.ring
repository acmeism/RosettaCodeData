# Project : Substitution Cipher

plaintext = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
ciphertext = "ZEBRASCDFGHIJKLMNOPQTUVWXY"
test = "flee at once. we are discovered!"
encrypt = "SIAA ZQ LKBA. VA ZOA RFPBLUAOAR!"

see "Plaintext : " + plaintext + nl
see "Ciphertext : " + ciphertext + nl
see "Test : " + test + nl
see "Encoded : "
encodetext = encode(test)
see encodetext + nl
see "Decoded : "
decodetext = decode(encodetext)
see decodetext + nl

func encode(test)
        str = ""
        for n = 1 to len(test)
              pos = substr(plaintext, upper(test[n]))
              if test[n] = " "
                 str = str + " "
              elseif test[n] = "!"
                 str = str + "!"
              elseif test[n] = "."
                 str = str + "."
              else
                 str = str + substr(ciphertext, pos, 1)
              ok
        next
        return str

func decode(test)
        str = ""
        for n = 1 to len(encodetext)
              pos = substr(ciphertext, upper(encodetext[n]))
              if test[n] = " "
                 str = str + " "
              elseif test[n] = "!"
                 str = str + "!"
              elseif test[n] = "."
                 str = str + "."
              else
                 str = str + lower(substr(plaintext, pos, 1))
              ok
        next
        return str
