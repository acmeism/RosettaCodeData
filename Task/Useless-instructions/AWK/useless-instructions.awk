# syntax: GAWK -f USELESS_INSTRUCTIONS.AWK
BEGIN {
# create an array with two elements
    n = split("item1,item2",array,",")
# delete array by removing one element at a time
    for (i=1; i<=n; i++) { delete array[i] }
# delete entire array; available in "old" awk onward
    split("",array)
# delete entire array; became available in "new" awk; redundant
    delete array
}
