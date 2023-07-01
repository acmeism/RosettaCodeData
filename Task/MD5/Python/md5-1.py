>>> import hashlib
>>> # RFC 1321    test suite:
>>> tests = (
  (b"", 'd41d8cd98f00b204e9800998ecf8427e'),
  (b"a", '0cc175b9c0f1b6a831c399e269772661'),
  (b"abc", '900150983cd24fb0d6963f7d28e17f72'),
  (b"message digest", 'f96b697d7cb7938d525a2f31aaf161d0'),
  (b"abcdefghijklmnopqrstuvwxyz", 'c3fcd3d76192e4007dfb496cca67e13b'),
  (b"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789", 'd174ab98d277d9f5a5611c2c9f419d9f'),
  (b"12345678901234567890123456789012345678901234567890123456789012345678901234567890", '57edf4a22be3c955ac49da2e2107b67a') )
>>> for text, golden in tests: assert hashlib.md5(text).hexdigest() == golden

>>>
