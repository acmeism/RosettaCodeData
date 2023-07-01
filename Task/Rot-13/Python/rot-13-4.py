#!/usr/bin/env python
from __future__ import print_function
import string
lets = string.ascii_lowercase
key = {x:y for (x,y) in zip(lets[13:]+lets[:14], lets)}
key.update({x.upper():key[x].upper() for x in key.keys()})
encode = lambda x: ''.join((key.get(c,c) for c in x))
if __name__ == '__main__':
   """Peform line-by-line rot-13 encoding on any files listed on our
      command line or act as a standard UNIX filter (if no arguments
      specified).
   """
   import fileinput
   for line in fileinput.input():
      print(encode(line), end="")
