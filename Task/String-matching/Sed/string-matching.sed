# 1. Determining if the first string starts with the second string:

N;/^\(.*\).*\n\1$/!d;s/\n.*//

# 2. Determining if the first string contains the second string at any location:

N;/.*\(.*\).*\n\1$/!d;s/\n.*//

# 3. Determining if the first string ends with the second string:

N;/\(.*\)\n\1$/!d;s/\n.*//
