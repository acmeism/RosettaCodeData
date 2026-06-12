import string

sometext = """All children, except one, grow up. They soon know that they will grow
up, and the way Wendy knew was this. One day when she was two years old
she was playing in a garden, and she plucked another flower and ran with
it to her mother. I suppose she must have looked rather delightful, for
Mrs. Darling put her hand to her heart and cried, "Oh, why can't you
remain like this for ever!" This was all that passed between them on
the subject, but henceforth Wendy knew that she must grow up. You always
know after you are two. Two is the beginning of the end.

Of course they lived at 14 [their house number on their street], and
until Wendy came her mother was the chief one. She was a lovely lady,
with a romantic mind and such a sweet mocking mouth. Her romantic
mind was like the tiny boxes, one within the other, that come from the
puzzling East, however many you discover there is always one more; and
her sweet mocking mouth had one kiss on it that Wendy could never get,
though there it was, perfectly conspicuous in the right-hand corner.""".lower()

lc2bin = {ch: '{:05b}'.format(i)
          for i, ch in enumerate(string.ascii_lowercase + ' .')}
bin2lc = {val: key for key, val in lc2bin.items()}

phrase = 'Rosetta code Bacon cipher example secret phrase to encode in the capitalisation of peter pan'.lower()

def to_5binary(msg):
    return ( ch == '1' for ch in ''.join(lc2bin.get(ch, '') for ch in msg.lower()))

def encrypt(message, text):
    bin5 = to_5binary(message)
    textlist = list(text.lower())
    out = []
    for capitalise in bin5:
        while textlist:
            ch = textlist.pop(0)
            if ch.isalpha():
                if capitalise:
                    ch = ch.upper()
                out.append(ch)
                break
            else:
                out.append(ch)
        else:
            raise Exception('ERROR: Ran out of characters in sometext')
    return ''.join(out) + '...'


def  decrypt(bacontext):
    binary = []
    bin5 = []
    out = []
    for ch in bacontext:
        if ch.isalpha():
            binary.append('1' if ch.isupper() else '0')
            if len(binary) == 5:
                bin5 = ''.join(binary)
                out.append(bin2lc[bin5])
                binary = []
    return ''.join(out)


print('PLAINTEXT = \n%s\n' % phrase)
encrypted = encrypt(phrase, sometext)
print('ENCRYPTED = \n%s\n' % encrypted)
decrypted = decrypt(encrypted)
print('DECRYPTED = \n%s\n' % decrypted)
assert phrase == decrypted, 'Round-tripping error'
