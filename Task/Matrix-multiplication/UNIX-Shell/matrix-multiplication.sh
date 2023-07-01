#!/bin/bash

DELAY=0 # increase this if printing of matrices should be slower

echo "This script takes two matrices, henceforth called A and B,
and returns their product, AB.

For the time being, matrices can have integer components only.

"

read -p "Number of rows    of matrix A:  " arows
read -p "Number of columns of matrix A:  " acols
brows="$acols"
echo
echo    "Number of rows    of matrix B:  "$brows
read -p "Number of columns of matrix B:  " bcols

crows="$arows"
ccols="$bcols"
echo

echo "Number of rows    of matrix AB:  " $crows
echo "Number of columns of matrix AB:  " $ccols
echo
echo

matrixa=( )
matrixb=( )

# input matrix A

maxlengtha=0
for ((row=1; row<=arows; row++)); do
    for ((col=1; col<=acols; col++)); do
	checkentry="false"
	while [ "$checkentry" != "true" ]; do
	    read -p "Enter component A[$row, $col]:  " number
	    index=$(((row-1)*acols+col))
	    matrixa[$index]="$number"
	    [ "${matrixa[$index]}" -eq "$number" ] && checkentry="true"
	    echo
	done
	entry="${matrixa[$index]}"
	[ "${#entry}" -gt "$maxlengtha" ] && maxlengtha="${#entry}"
    done
    echo
done

# print matrix A to guard against errors

if [ "$maxlengtha" -le "5" ]; then
    width=8
else
    width=$((maxlengtha + 3))
fi

echo "This is matrix A:

"

for ((row=1; row<=arows; row++)); do
    for ((col=1; col<=acols; col++)); do

	index=$(((row-1)*acols+col))
	printf "%${width}d" "${matrixa[$index]}"
	sleep "$DELAY"

    done
    echo; echo # printf %s "\n\n" does not work...
done

echo
echo

# input matrix B

maxlengthb=0
for ((row=1; row<=brows; row++)); do
    for ((col=1; col<=bcols; col++)); do
	checkentry="false"
	while [ "$checkentry" != "true" ]; do
	    read -p "Enter component B[$row, $col]:  " number
	    index=$(((row-1)*bcols+col))
	    matrixb[$index]="$number"
	    [ "${matrixb[$index]}" -eq "$number" ] && checkentry="true"
	    echo
	done
	entry="${matrixb[$index]}"
	[ "${#entry}" -gt "$maxlengthb" ] && maxlengthb="${#entry}"
    done
    echo
done

# print matrix B to guard against errors

if [ "$maxlengthb" -le "5" ]; then
    width=8
else
    width=$((maxlengthb + 3))
fi

echo "This is matrix B:

"

for ((row=1; row<=brows; row++)); do
    for ((col=1; col<=bcols; col++)); do

	index=$(((row-1)*bcols+col))
	printf "%${width}d" "${matrixb[$index]}"
	sleep "$DELAY"

    done
    echo; echo # printf %s "\n\n" does not work...
done

read -p "Hit enter to continue"

# calculate matrix C := AB

maxlengthc=0
time for ((row=1; row<=crows; row++)); do
    for ((col=1; col<=ccols; col++)); do
	
	# calculate component C[$row, $col]

	runningtotal=0
	for ((j=1; j<=acols; j++)); do
	    rowa="$row"
	    cola="$j"
	    indexa=$(((rowa-1)*acols+cola))
	    rowb="$j"
	    colb="$col"
	    indexb=$(((rowb-1)*bcols+colb))
	
	    entry_from_A=${matrixa[$indexa]}
	    entry_from_B=${matrixb[$indexb]}

	    subtotal=$((entry_from_A * entry_from_B))
	    ((runningtotal+=subtotal))
	done
	
	number="$runningtotal"

	# store component in the result array
	index=$(((row-1)*ccols+col))
	matrixc[$index]="$number"

	entry="${matrixc[$index]}"
	[ "${#entry}" -gt "$maxlengthc" ] && maxlengthc="${#entry}"
    done
done

echo
read -p "Hit enter to continue"
echo

# print the matrix C

if [ "$maxlengthc" -le "5" ]; then
    width=8
else
    width=$((maxlengthc + 3))
fi

echo "The product matrix is:

"

for ((row=1; row<=crows; row++)); do
    for ((col=1; col<=ccols; col++)); do

	index=$(((row-1)*ccols+col))
	printf "%${width}d" "${matrixc[$index]}"
	sleep "$DELAY"

    done
    echo; echo # printf %s "\n\n" does not work...
done

echo
echo
