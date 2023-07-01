rec1=(
    jsmith
    x
    1001
    1000
    "Joe Smith,Room 1007,(234)555-8917,(234)555-0077,jsmith@rosettacode.org"
    /home/jsmith
    /bin/bash
)

rec2=(
    jdoe
    x
    1002
    1000
    "Jane Doe,Room 1004,(234)555-8914,(234)555-0044,jdoe@rosettacode.org"
    /home/jdoe
    /bin/bash
)

rec3=(
    xyz
    x
    1003
    1000
    "X Yz,Room 1003,(234)555-8913,(234)555-0033,xyz@rosettacode.org"
    /home/xyz
    /bin/bash
)

filename=./passwd-ish

# use parentheses to run the commands in a subshell, so the
# current shell's IFS variable is not changed
(
    IFS=:
    echo "${rec1[*]}"
    echo "${rec2[*]}"
) > "$filename"

echo before appending:
cat "$filename"

# appending, use the ">>" redirection symbol
IFS=:
echo "${rec3[*]}" >> "$filename"

echo after appending:
cat "$filename"
