# assign an empty string to a variable
s=""

# the "test" command can determine truth by examining the string itself
if [ "$s" ]; then echo "not empty"; else echo "empty"; fi

# compare the string to the empty string
if [ "$s" = "" ]; then echo "s is the empty string"; fi
if [ "$s" != "" ]; then echo "s is not empty"; fi

# examine the length of the string
if [ -z "$s" ]; then echo "the string has length zero: it is empty"; fi
if [ -n "$s" ]; then echo "the string has length non-zero: it is not empty"; fi
