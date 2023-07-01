gawk 'BEGINFILE{if (ERRNO) {print "Not exist."; nextfile} else {print "Exist."; nextfile}}' input.txt input-missing.txt
