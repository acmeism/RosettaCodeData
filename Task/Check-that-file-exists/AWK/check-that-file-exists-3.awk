gawk 'BEGINFILE{if (ERRNO) {print "Not exist."; exit} } {print "Exist."; exit}' input.txt
