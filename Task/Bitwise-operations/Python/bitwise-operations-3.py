# 8-bit bounded shift:
x = x << n & 0xff
# ditto for 16 bit:
x = x << n & 0xffff
# ... and 32-bit:
x = x << n & 0xffffffff
# ... and 64-bit:
x = x << n & 0xffffffffffffffff
