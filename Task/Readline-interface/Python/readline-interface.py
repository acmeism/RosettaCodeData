#!/usr/bin/env python3

#
# A simple readline demo that does nothing.
# Interactive line editing and history active
#

import readline

while True:
    try:
        print(input('> '))
    except:
        break
