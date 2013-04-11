#!/usr/bin/env python
import sys
try:
   a = int(raw_input('Enter value of a: '))
   b = int(raw_input('Enter value of b: '))
except (ValueError, EnvironmentError), err:
   print sys.stderr, "Erroneous input:", err
   sys.exit(1)

dispatch = {
    -1: 'is less than',
     0: 'is equal to',
     1: 'is greater than'
     }
 print a, dispatch[cmp(a,b)], b
