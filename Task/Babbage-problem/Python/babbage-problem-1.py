# Lines that start by # are a comments:
# they will be ignored by the machine

n=0 # n is a variable and its value is 0

# we will increase its value by one until
# its square ends in 269,696

while n**2 % 1000000 != 269696:

    # n**2 -> n squared
    # %    -> 'modulo' or remainder after division
    # !=   -> not equal to

    n += 1 # += -> increase by a certain number

print(n) # prints n
