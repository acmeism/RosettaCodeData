# syntax: GAWK -f SORT_AN_ARRAY_OF_COMPOSITE_STRUCTURES.AWK
BEGIN {
# AWK lacks structures but one can be simulated using an associative array.
    arr["eight  8 "]
    arr["two    2 "]
    arr["five   5 "]
    arr["nine   9 "]
    arr["one    1 "]
    arr["three  3 "]
    arr["six    6 "]
    arr["seven  7 "]
    arr["four   4 "]
    arr["ten    10"]
    arr["zero   0 "]
    arr["twelve 12"]
    arr["minus2 -2"]
    show(1,7,"@val_str_asc","name") # use name part of name-value pair
    show(8,9,"@val_num_asc","value") # use value part of name-value pair
    exit(0)
}
function show(a,b,sequence,description,  i,x) {
    PROCINFO["sorted_in"] = "@unsorted"
    for (i in arr) {
      x = substr(i,a,b)
      sub(/ +/,"",x)
      arr[i] = x
    }
    PROCINFO["sorted_in"] = sequence
    printf("sorted by %s:",description)
    for (i in arr) {
      printf(" %s",arr[i])
    }
    printf("\n")
}
