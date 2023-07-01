alist=( item1 item2 item3 )  # creates a 3 item array called "alist"
declare -a list2        # declare an empty list called "list2"
declare -a list3[0]     # empty list called "list3"; the subscript is ignored

# create a 4 item list, with a specific order
list5=([3]=apple [2]=cherry [1]=banana [0]=strawberry)
