i = 0
while 1: # infinite loop
    try:
       temp2 = 0/i # will raise a ZeroDivisionError first.
       temp = math.sqrt(i)

       break # 'break' will break out of the while loop
    except ValueError: #
        print "Imaginary Number! Breaking out of loop"
        break # 'break' out of while loop
    except ZeroDivisionError:
        print "You've divided by zero. Decrementing i and continuing..."
        i-=1 # we decrement i.
        # we 'continue', everything within the try - except block will be executed again,
        # this time however, ZeroDivisionError would not be raised again.
        continue # Note that removing it, replacing it with 'pass' would perform the equivalent
                 # see below for a better example
# Output :
# You've divided by zero. Decrementing i and continuing...
# Imaginary Number! Breaking out of loop
