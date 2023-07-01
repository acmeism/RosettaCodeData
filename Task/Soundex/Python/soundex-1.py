from itertools import groupby

def soundex(word):
   codes = ("bfpv","cgjkqsxz", "dt", "l", "mn", "r")
   soundDict = dict((ch, str(ix+1)) for ix,cod in enumerate(codes) for ch in cod)
   cmap2 = lambda kar: soundDict.get(kar, '9')
   sdx =  ''.join(cmap2(kar) for kar in word.lower())
   sdx2 = word[0].upper() + ''.join(k for k,g in list(groupby(sdx))[1:] if k!='9')
   sdx3 = sdx2[0:4].ljust(4,'0')
   return sdx3
