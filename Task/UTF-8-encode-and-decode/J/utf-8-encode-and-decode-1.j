utf8=: 8&u:               NB. converts to UTF-8 from unicode or unicode codepoint integer
ucp=: 9&u:                NB. converts to unicode from UTF-8 or unicode codepoint integer
ucp_hex=: hfd@(3 u: ucp)  NB. converts to unicode codepoint hexadecimal from UTF-8, unicode or unicode codepoint integer
