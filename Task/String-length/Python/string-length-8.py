# The letter Alef
print(len('\u05d0'.encode())) # the default encoding is utf-8 in Python3
# 2
print(len('\u05d0'.encode('iso-8859-8')))
# 1
