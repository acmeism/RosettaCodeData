import string
def caesar(s, k, decode = False):
   if decode: k = 26 - k
   return s.translate(
       string.maketrans(
           string.ascii_uppercase + string.ascii_lowercase,
           string.ascii_uppercase[k:] + string.ascii_uppercase[:k] +
           string.ascii_lowercase[k:] + string.ascii_lowercase[:k]
           )
       )
msg = "The quick brown fox jumped over the lazy dogs"
print msg
enc = caesar(msg, 11)
print enc
print caesar(enc, 11, decode = True)
