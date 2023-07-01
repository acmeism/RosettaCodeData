classes = (str.isupper, str.islower, str.isalnum, str.isalpha, str.isdecimal,
           str.isdigit, str.isidentifier, str.isnumeric, str.isprintable,
           str.isspace, str.istitle)

for stringclass in classes:
    chars = ''.join(chr(i) for i in range(0x10FFFF+1) if stringclass(chr(i)))
    print('\nString class %s has %i characters the first of which are:\n  %r'
          % (stringclass.__name__, len(chars), chars[:100]))
