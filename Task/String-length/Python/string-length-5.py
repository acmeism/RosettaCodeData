print len('ascii')
# 5
print len(u'\u05d0') # the letter Alef as unicode literal
# 1
print len('\xd7\x90'.decode('utf-8')) # Same encoded as utf-8 string
# 1
print hex(sys.maxunicode), len(unichr(0x1F4A9))
# ('0x10ffff', 1)
