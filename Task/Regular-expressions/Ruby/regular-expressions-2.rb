str.sub(/ a /, ' another ') #=> "I am another string"
# Or:
str[/ a /] = ' another '    #=> "another"
str                         #=> "I am another string"
