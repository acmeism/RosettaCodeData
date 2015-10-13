#!/usr/bin/env python3

import binascii
import functools
import hashlib

digits58 = b'123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'

def b58(n):
    return b58(n//58) + digits58[n%58:n%58+1] if n else b''

def public_point_to_address(x, y):
    c = b'\x04' + binascii.unhexlify(x) + binascii.unhexlify(y)
    r = hashlib.new('ripemd160')
    r.update(hashlib.sha256(c).digest())
    c = b'\x00' + r.digest()
    d = hashlib.sha256(hashlib.sha256(c).digest()).digest()
    return b58(functools.reduce(lambda n, b: n<<8|b, c + d[:4]))

if __name__ == '__main__':
    print(public_point_to_address(
        b'50863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B2352',
        b'2CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6'))
