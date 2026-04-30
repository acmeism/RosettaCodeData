# syntax: GAWK -f SELECTIVELY_REPLACE_MULTIPLE_INSTANCES_OF_A_CHARACTER_WITHIN_A_STRING.AWK
BEGIN {
    str = "abracadabra"
    printf("old: %s\n",str)
    str = gensub(/r/,"F",2,str) # replace 2nd 'r' with 'F'
    str = gensub(/b/,"E",1,str) # replace 1st 'b' with 'E'
    str = gensub(/a/,"D",5,str) # replace 5th 'a' with 'D'
    str = gensub(/a/,"C",4,str) # replace 4th 'a' with 'C'
    str = gensub(/a/,"B",2,str) # replace 2nd 'a' with 'B'
    str = gensub(/a/,"A",1,str) # replace 1st 'a' with 'A'
    printf("new: %s\n",str)
    exit(0)
}
