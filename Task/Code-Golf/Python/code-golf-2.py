print(end=0x436f646520476f6c66.to_bytes(9).decode())

# or:

for c in 37,9,2,3,70,33,9,10,0:print(end=chr(c^102))
