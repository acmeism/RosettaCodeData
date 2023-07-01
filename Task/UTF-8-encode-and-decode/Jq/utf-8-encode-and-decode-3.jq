# input: an array of decimal integers representing the utf-8 bytes of a Unicode codepoint.
# output: the corresponding decimal number of that codepoint.
def utf8_decode:
   # Magic numbers:
   # x80: 128,       # 10000000
   # xe0: 224,       # 11100000
   # xf0: 240        # 11110000
     (-6) as $mb     # non-first bytes start 10 and carry 6 bits of data
                     # first byte of a 2-byte encoding starts 110 and carries 5 bits of data
                     # first byte of a 3-byte encoding starts 1110 and carries 4 bits of data
                     # first byte of a 4-byte encoding starts 11110 and carries 3 bits of data
   | map(binary_digits) as $d
   | .[0]
   | if   . < 128 then $d[0]
     elif . < 224 then $d[0][-5:] + $d[1][$mb:]
     elif . < 240 then $d[0][-4:] + $d[1][$mb:] + $d[2][$mb:]
     else              $d[0][-3:] + $d[1][$mb:] + $d[2][$mb:] + $d[3][$mb:]
     end
   | binary_to_decimal ;
