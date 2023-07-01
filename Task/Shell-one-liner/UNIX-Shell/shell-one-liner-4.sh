$ VAR=`echo hello`   # obsolescent backtick notation
$ VAR=$(echo hello)  # modern POSIX notation
$ (echo hello)       # execute in another shell process, not in this one
