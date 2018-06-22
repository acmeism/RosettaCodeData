# Project : Vigenère cipher
# Date    : 2018/01/02
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

key = "LEMON"
plaintext = "ATTACK AT DAWN"
ciphertext = encrypt(plaintext, key)
see "key = "+ key + nl
see "plaintext  = " + plaintext + nl
see "ciphertext = " + ciphertext + nl
see "decrypted  = " + decrypt(ciphertext, key) + nl


func encrypt(plain, key)
        o = ""
        k = 0
        plain = fnupper(plain)
        key = fnupper(key)
        for i = 1 to len(plain)
             n = ascii(plain[i])
             if n >= 65 and n <= 90
                o = o + char(65 + (n + ascii(key[k+1])) % 26)
                k = (k + 1) % len(key)
             ok
        next
        return o

func decrypt(cipher, key)
        o = ""
        k = 0
        cipher = fnupper(cipher)
        key = fnupper(key)
        for i = 1 to len(cipher)
             n = ascii(cipher[i])
             o = o + char(65 + (n + 26 - ascii(key[k+1])) % 26)
             k = (k + 1) % len(key)
        next
        return o

func fnupper(a)
        for aa = 1 to len(a)
             c = ascii(a[aa])
            if c >= 97 and c <= 122
               a[aa] = char(c-32)
           ok
        next
        return a
