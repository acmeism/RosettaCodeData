# Let's call our custom error "StupidError"; it inherits from the Exception class

class StupidError(Exception): pass

# Try it out.
try:
    raise StupidError("Segfault") # here, we manually 'raise' the error within the try block
except StupidError, details: # 'details' is the StupidError object we create in the try block.
    print 'Something stupid occurred:', details # so we access the value we had stored for it...


# Output :
# Something stupid occurred: Segfault
