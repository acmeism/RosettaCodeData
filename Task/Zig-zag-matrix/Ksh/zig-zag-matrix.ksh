#!/bin/ksh

# Produce a zig-zag array.

#	# Variables:
#
integer DEF_SIZE=5			# Default size = 5
arr_size=${1:-$DEF_SIZE}	# $1 = size, or default

    #	# Externals:
    #

#	# Functions:
#


 ######
# main #
 ######
integer i j n
typeset -a zzarr

for (( i=n=0; i<arr_size*2; i++ )); do
	for (( j= (i<arr_size) ? 0 : i-arr_size+1; j<=i && j<arr_size; j++ )); do
		(( zzarr[(i&1) ? j*(arr_size-1)+i : (i-j)*arr_size+j] = n++ ))
	done
done

for ((i=0; i<arr_size*arr_size; i++)); do
	printf "%3d " ${zzarr[i]}
	(( (i+1)%arr_size == 0 )) && printf "\n"
done
