Message:= "
(join
bacon's cipher is a method of steganography created by francis bacon.
this task is to implement a program for encryption and decryption of
plaintext using the simple alphabet of the baconian cipher or some
other kind of representation of this alphabet (make anything signify anything).
the baconian alphabet may optionally be extended to encode all lower
case characters individually and/or adding a few punctuation characters
such as the space.
)"

plaintext := "the quick brown fox jumps over the lazy dog"

MsgBox, 262144, ,% "plain text = " plaintext
                . "`n`nencoded = `n" (cipher := Bacon_Cipher(message, plaintext))
                . "`n`ndecoded = " recoveredText := Bacon_Cipher(cipher)
