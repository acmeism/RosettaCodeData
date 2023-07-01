# 2 chars starting from 3rd
$ echo string | sed -r 's/.{3}(.{2}).*/\1/'
in
# remove first 3 chars
echo string | sed -r 's/^.{3}//'
# delete last char
$ echo string | sed -r 's/.$//'
strin
# `r' with two following chars
$ echo string | sed -r 's/.*(r.{2}).*/\1/'
rin
