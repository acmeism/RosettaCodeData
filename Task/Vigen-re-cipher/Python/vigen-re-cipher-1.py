from itertools import starmap, cycle

def encrypt(message, key):

    # convert to uppercase.
    # strip out non-alpha characters.
    message = filter(str.isalpha, message.upper())

    # single letter encrpytion.
    def enc(c,k): return chr(((ord(k) + ord(c) - 2*ord('A')) % 26) + ord('A'))

    return "".join(starmap(enc, zip(message, cycle(key))))

def decrypt(message, key):

    # single letter decryption.
    def dec(c,k): return chr(((ord(c) - ord(k) - 2*ord('A')) % 26) + ord('A'))

    return "".join(starmap(dec, zip(message, cycle(key))))
