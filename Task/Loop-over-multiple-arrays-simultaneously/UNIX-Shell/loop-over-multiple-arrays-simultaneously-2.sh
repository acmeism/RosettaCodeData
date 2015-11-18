A='a1 a2 a3'
B='b1 b2 b3'

set -- $B
for a in $A
do
    printf "$a $1\n"
    shift
done
