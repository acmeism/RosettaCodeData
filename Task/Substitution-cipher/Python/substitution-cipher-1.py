from string import printable
import random

EXAMPLE_KEY = ''.join(sorted(printable, key=lambda _:random.random()))

def encode(plaintext, key):
    return ''.join(key[printable.index(char)] for char in plaintext)

def decode(plaintext, key):
    return ''.join(printable[key.index(char)] for char in plaintext)

original = "A simple example."
encoded = encode(original, EXAMPLE_KEY)
decoded = decode(encoded, EXAMPLE_KEY)
print("""The original is: {}
Encoding it with the key: {}
Gives: {}
Decoding it by the same key gives: {}""".format(
    original, EXAMPLE_KEY, encoded, decoded))
