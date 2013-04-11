# In the shell all variables are stored as strings, so we use the same technique
# as for finding the length of a string:
greeting='Hello, world!'
greetinglength=`printf '%s' "$greeting" | wc -c`
echo "The greeting is $greetinglength characters in length"
