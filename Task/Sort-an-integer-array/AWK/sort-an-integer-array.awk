# syntax: GAWK -f SORT_AN_INTEGER_ARRAY.AWK
BEGIN {
    split("9,10,3,1234,99,1,200,2,0,-2",arr,",")
    show("@unsorted","unsorted")
    show("@val_num_asc","sorted ascending")
    show("@val_num_desc","sorted descending")
    exit(0)
}
function show(sequence,description,  i) {
    PROCINFO["sorted_in"] = sequence
    for (i in arr) {
      printf("%s ",arr[i])
    }
    printf("\t%s\n",description)
}
