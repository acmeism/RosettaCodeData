cStr = "a":"h"  # 'abcdefgh'
n = 3  m = 3
# starting from n characters in and of m length
See substr(cStr,n, m) + nl          #=> cde
# starting from n characters in, up to the end of the string
See substr(cStr,n) + nl             #=> cdefgh
# whole string minus last character
See substr(cstr,1,len(cStr)-1) + nl #=> abcdefg
# starting from a known character within the string and of m length
See substr(cStr,substr(cStr,"e"),m) +nl #=> efg
# starting from a known substring within the string and of m length
See substr(cStr,substr(cStr,"de"),m) +nl #=> def
