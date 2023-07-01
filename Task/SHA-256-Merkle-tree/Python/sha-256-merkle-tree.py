#!/usr/bin/env python
# compute the root label for a SHA256 Merkle tree built on blocks of a given
# size (default 1MB) taken from the given file(s)
import argh
import hashlib
import sys

@argh.arg('filename', nargs='?', default=None)
def main(filename, block_size=1024*1024):
    if filename:
        fin = open(filename, 'rb')
    else:
        fin = sys.stdin

    stack = []
    block = fin.read(block_size)
    while block:
        # a node is a pair: ( tree-level, hash )
        node = (0, hashlib.sha256(block).digest())
        stack.append(node)

        # concatenate adjacent pairs at the same level
        while len(stack) >= 2 and stack[-2][0] == stack[-1][0]:
            a = stack[-2]
            b = stack[-1]
            l = a[0]
            stack[-2:] = [(l+1, hashlib.sha256(a[1] + b[1]).digest())]

        block = fin.read(block_size)

    while len(stack) > 1:
        # at the end we have to concatenate even across levels
        a = stack[-2]
        b = stack[-1]
        al = a[0]
        bl = b[0]
        stack[-2:] = [(max(al, bl)+1, hashlib.sha256(a[1] + b[1]).digest())]

    print(stack[0][1].hex())


argh.dispatch_command(main)
