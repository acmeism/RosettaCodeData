def bitstr(n, width=None):
   """return the binary representation of n as a string and
      optionally zero-fill (pad) it to a given length
   """
   result = list()
   while n:
      result.append(str(n%2))
      n = int(n/2)
   if (width is not None) and len(result) < width:
      result.extend(['0'] * (width - len(result)))
   result.reverse()
   return ''.join(result)

def mask(n):
   """Return a bitmask of length n (suitable for masking against an
      int to coerce the size to a given length)
   """
   if n >= 0:
       return 2**n - 1
   else:
       return 0

def rol(n, rotations=1, width=8):
    """Return a given number of bitwise left rotations of an integer n,
       for a given bit field width.
    """
    rotations %= width
    if rotations < 1:
        return n
    n &= mask(width) ## Should it be an error to truncate here?
    return ((n << rotations) & mask(width)) | (n >> (width - rotations))

def ror(n, rotations=1, width=8):
    """Return a given number of bitwise right rotations of an integer n,
       for a given bit field width.
    """
    rotations %= width
    if rotations < 1:
        return n
    n &= mask(width)
    return (n >> rotations) | ((n << (width - rotations)) & mask(width))
