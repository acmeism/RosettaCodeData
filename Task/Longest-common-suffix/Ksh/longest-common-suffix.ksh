#!/bin/ksh

# Longest common suffix

# # Variables:
#
typeset -a arr1=( "Sunday" "Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" )
typeset -a arr2=( "baabababc" "baabc" "bbbabc" )
typeset -a arr3=( "baabababc" "babc" "bbbabc" )
typeset -a arr4=( "longest" "common" "suffix" )
typeset -a arr5=( "suffix" )
typeset -a arr6=( "" )

# # Functions:
#

# # Function _minlenele(arr) - return the shortest element in an array
#
function _minlenele {
  typeset _arr ; nameref _arr="$1"
  typeset _min _i ; integer _i

  _min=${_arr[0]}
  for ((_i=1; _i<${#_arr[*]}; _i++)); do
    (( ${#_arr[_i]} < ${#_min} )) && _min=${_arr[_i]}
  done
  echo "${_min}"
}

 ######
# main #
 ######

for array in arr1 arr2 arr3 arr4 arr5 arr6; do
  nameref arr=${array}
  printf "\n( %s ) -> " "${arr[*]}"
  suffix=$(_minlenele arr)
  for ((j=${#suffix}; j>0; j--)); do
    for ((i=0; i<${#arr[*]}; i++)); do
      [[ ${arr[i]%${suffix: -${j}}} == ${arr[i]} ]] && continue 2
    done
    printf "'%s'" ${suffix: -${j}}
    break
  done
  typeset +n arr
done
echo
