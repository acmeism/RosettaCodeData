str2hex = do ->
  hex = ['0', '1', '2', '3', '4', '5', '6', '7',
         '8', '9', 'a', 'b', 'c', 'd', 'e', 'f']
  hex = (hex[x >> 4] + hex[x & 15] for x in [0..255])
  (str) ->
    (hex[c.charCodeAt()] for c in str).join ''

console.log str2hex md5 message for message in [
  ""
  "a"
  "abc"
  "message digest"
  "abcdefghijklmnopqrstuvwxyz"
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
  "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
]
