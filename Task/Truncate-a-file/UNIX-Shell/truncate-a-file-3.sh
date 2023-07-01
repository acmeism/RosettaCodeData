# 1. simplest one-liner
-bash$ >file

# or the more clear/verbose:
echo -n>file

# 2. checks for file as input prior to truncate:
f="file";echo -n<$f>$f

# double-check file size
ls -1 file # it's trunc

# 3. multiple files (glob)
glob=$(ls -1 file[0-9]); for f in $glob; do echo -n<$f>$f; done


## OUTPUT:
# 1. one-liner
-bash-4.2$ echo -n>bad
+ echo -n
-bash-4.2$ ls -l bad; cat bad
+ ls -l bad
-rw-r--r--  1 fieldsa  fieldsa  0 Dec  4 20:07 bad
+ cat bad
-bash-4.2$

# 2. checks
-bash-4.2$ set -x; f="bad"; echo -n<$f>$f
+ f=bad
+ echo -n
-bash: bad: No such file or directory

# Try again with the shortest version: f="bad"<$f>$f
+ ls -l bad
-rw-r--r--  1 fieldsa  fieldsa  8192 Dec  5 01:04 bad
-bash-4.2$ f="bad" <$f>$f
+ f=bad
-bash-4.2$ ls -l
+ ls -l
-rw-r--r--  1 fieldsa  fieldsa       0 Dec  5 01:04 bad
-bash-4.2$ rm bad
+ rm bad
-bash-4.2$ f="bad" <$f>$f
+ f=bad
-bash: bad: No such file or directory

# Now a bad file exists
-bash-4.2$ echo 'abc'>bad
+ echo abc
-bash-4.2$ ls -l bad;cat<bad
+ ls -l bad
-rw-r--r--  1 fieldsa  fieldsa  4 Dec  4 19:21 bad
+ cat
abc

-bash-4.2$ f="bad"; echo -n<$f>$f
+ f=bad
+ echo -n
-bash-4.2$ ls -l bad;cat<bad;echo "_EOF_"
+ ls -l bad
-rw-r--r--  1 fieldsa  fieldsa  0 Dec  4 19:23 bad
+ cat
+ echo _EOF_
_EOF_

-bash-4.2$ rm bad
+ rm bad
-bash-4.2$ f="bad" <$f&&echo -n>$f
+ f=bad
-bash: bad: No such file or directory

# 4. trunc(): trunc file size # truncate at length
-bash-4.2$ trunc() { IFS= read -N $2 b<"$1"; echo -n "$b">"$1"; }
-bash-4.2$ echo "abcdef">bad; ls -l bad; cat bad; trunc bad 3; ls -l bad; cat bad; echo "_EOF_"
+ echo abcdef
+ ls -l bad
-rw-r--r--  1 fieldsa  fieldsa  7 Dec  4 19:59 bad
+ cat bad
abcdef
+ trunc bad 3
+ read -N 3 b
+ echo -n abc
+ ls -l bad
-rw-r--r--  1 fieldsa  fieldsa  3 Dec  4 19:59 bad
+ cat bad
abc+ echo _EOF_
_EOF_
