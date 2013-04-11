text = "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!"
key = "VIGENERECIPHER"

encr = encrypt(text, key)
decr = decrypt(encr, key)

print text
print encr
print decr
