>>> s = 'The quick brown fox jumps over the lazy dog'
>>> import zlib
>>> hex(zlib.crc32(s))
'0x414fa339'

>>> import binascii
>>> hex(binascii.crc32(s))
'0x414fa339'
