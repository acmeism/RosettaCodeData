use Digest::SHA1::Native;

# use sha1-hex() if you want a hex string

say sha1($_), "  $_" for
  'abc',
  'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq',
  'Rosetta Code',
  'Ars longa, vita brevis'
;
