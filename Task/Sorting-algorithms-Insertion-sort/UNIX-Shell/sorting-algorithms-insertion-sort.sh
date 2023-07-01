#!/bin/bash

# Sorting integers with insertion sort

function  insertion_sort ()
{
    # input: unsorted integer array
    # output:  sorted integer array (ascending)

    # local variables
    local -a arr         # array
    local -i i           # integers
    local -i j
    local -i key
    local -i prev
    local -i leftval
    local -i N          # size of array

    arr=( $@ )    # copy args into array

    N=${#arr[*]}  # arr extent
    readonly N    # make const

    # insertion sort
    for (( i=1; i<$N; i++ ))  # c-style for loop
    do
	key=$((arr[$i]))      # current value
	prev=$((arr[$i-1]))   # previous value
	j=$i                  # current index
	
	while [ $j -gt 0 ]  && [ $key -lt $prev ]  # inner loop
	do
	    arr[$j]=$((arr[$j-1])) # shift
	
	    j=$(($j-1))            # decrement

	    prev=$((arr[$j-1]))    # last value
	
	done
	
	arr[$j]=$(($key))          # insert key in proper order

    done

    echo ${arr[*]}                   # output sorted array
}

################
function main ()
{
    # main script
    declare -a sorted

    # use a default if no cmdline list
    if [ $# -eq 0 ]; then
	arr=(10 8 20 100 -3 12 4 -5 32 0 1)
    else
	arr=($@) #cmdline list of ints
    fi

    echo
    echo "original"
    echo -e "\t ${arr[*]} \n"

    sorted=($(insertion_sort ${arr[*]}))  # call function

    echo
    echo "sorted:"
    echo -e "\t ${sorted[*]} \n"
 }


#script starts here
# source or run
if [[ "$0" == "bash" ]]; then # script is sourced
    unset main
else
    main "$@"                 # call with cmdline args
fi

#END
