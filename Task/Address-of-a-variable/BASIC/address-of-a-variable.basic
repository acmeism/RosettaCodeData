'get a variable's address:
DIM x AS INTEGER, y AS LONG
y = VARPTR(x)

'can't set the address, but can access a given memory location... 1 byte at a time
DIM z AS INTEGER
z = PEEK(y)
z = z + (PEEK(y) * 256)
