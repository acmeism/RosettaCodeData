try:
    temp = 1/1 # not a division by zero error
except ZeroDivisionError: # so... it is not caught
    print "You've divided by zero."
# here, 'else' executes when no exceptions are caught...
else:
    print "No apparent error occurred."
# Output :
# No apparent error occurred.
