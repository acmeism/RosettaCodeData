#!/usr/bin/env python
import string
def rot13(s):
   """Implement the rot-13 encoding function: "rotate" each letter by the
      letter that's 13 steps from it (wrapping from z to a)
   """
   return s.translate(
       str.maketrans(
           string.ascii_uppercase + string.ascii_lowercase,
           string.ascii_uppercase[13:] + string.ascii_uppercase[:13] +
           string.ascii_lowercase[13:] + string.ascii_lowercase[:13]
           )
       )
if __name__ == "__main__":
   """Peform line-by-line rot-13 encoding on any files listed on our
      command line or act as a standard UNIX filter (if no arguments
      specified).
   """
   import fileinput
   for line in fileinput.input():
      print(rot13(line), end="")
