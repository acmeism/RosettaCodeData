try:
    temp = 0/0
except:
    print "An error occurred."
# here, 'finally' executes when the try - except block ends, regardless of whether an error was raised or not
# useful in areas such as closing opened file streams in the try block whether they were successfully opened or not
finally:
    print "End of 'try' block..."
# Output :
# An error occurred
# End of 'try' block...
