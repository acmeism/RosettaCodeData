#!/usr/bin/env python
# canonicalize a CIDR block specification:
# make sure none of the host bits are set

import sys
from socket import inet_aton, inet_ntoa
from struct import pack, unpack

args = sys.argv[1:]
if len(args) == 0:
    args = sys.stdin.readlines()

for cidr in args:
   # IP in dotted-decimal / bits in network part
   dotted, size_str = cidr.split('/')
   size = int(size_str)

   numeric = unpack('!I', inet_aton(dotted))[0]  # IP as an integer
   binary = f'{numeric:#034b}'                   # then as a padded binary string
   prefix = binary[:size + 2]                    # just the network part
                                                 #   (34 and +2 are to account
                                                 #    for leading '0b')

   canon_binary = prefix + '0' * (32 - size)     # replace host part with all zeroes
   canon_numeric = int(canon_binary, 2)          # convert back to integer
   canon_dotted = inet_ntoa(pack('!I',
                            (canon_numeric)))    # and then to dotted-decimal
   print(f'{canon_dotted}/{size}')               # output result
