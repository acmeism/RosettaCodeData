'''Vigenere encryption and decryption'''

from itertools import starmap, cycle


def encrypt(message, key):
    '''Vigenere encryption of message using key.'''

    # Converted to uppercase.
    # Non-alpha characters stripped out.
    message = filter(str.isalpha, message.upper())

    def enc(c, k):
        '''Single letter encryption.'''

        return chr(((ord(k) + ord(c) - 2 * ord('A')) % 26) + ord('A'))

    return ''.join(starmap(enc, zip(message, cycle(key))))


def decrypt(message, key):
    '''Vigenere decryption of message using key.'''

    def dec(c, k):
        '''Single letter decryption.'''

        return chr(((ord(c) - ord(k) - 2 * ord('A')) % 26) + ord('A'))

    return ''.join(starmap(dec, zip(message, cycle(key))))


def main():
    '''Demonstration'''

    text = 'Beware the Jabberwock, my son! The jaws that bite, ' + (
           'the claws that catch!'
    )
    key = 'VIGENERECIPHER'

    encr = encrypt(text, key)
    decr = decrypt(encr, key)

    print(text)
    print(encr)
    print(decr)


if __name__ == '__main__':
    main()
