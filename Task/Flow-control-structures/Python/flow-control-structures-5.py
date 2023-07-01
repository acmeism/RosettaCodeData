try:
    temp = 0/0
# here, 'except' catches a specific type of error raised within the try block.
except ZeroDivisionError:
    print "You've divided by zero!"
# Output : "You've divided by zero!"
