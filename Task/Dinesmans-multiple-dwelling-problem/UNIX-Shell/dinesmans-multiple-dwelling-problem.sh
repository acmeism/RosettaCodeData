#!/bin/bash

NAMES=(Baker Cooper Fletcher Miller Smith)

CRITERIA=(
  'Baker    != TOP'
  'Cooper   != BOTTOM'
  'Fletcher != TOP'
  'Fletcher != BOTTOM'
  'Miller   >  Cooper'
  '$(abs $(( Smith    - Fletcher )) ) > 1'
  '$(abs $(( Fletcher - Cooper   )) ) > 1'
)

# Code below here shouldn't need to change to vary parameters
let BOTTOM=0
let TOP=${#NAMES[@]}-1

# Not available as a builtin
function abs {
  let n=$1
  if (( n < 0 )); then let n=-n; fi
  echo "$n"
}

# Algorithm we use to iterate over the permutations
# requires that we start with the array sorted lexically
NAMES=($(printf "%s\n" "${NAMES[@]}" | sort))
while true; do
  # set each name to its position in the array
  for (( i=BOTTOM; i<=TOP; ++i )); do
    eval "${NAMES[i]}=$i"
  done

  # check to see if we've solved the problem
  let solved=1
  for criterion in "${CRITERIA[@]}"; do
    if ! eval "(( $criterion ))"; then
      let solved=0
      break
    fi
  done
  if (( solved )); then
    echo "From bottom to top: ${NAMES[@]}"
    break
  fi

  # Bump the names list to the next permutation
  let j=TOP-1
  while (( j >= BOTTOM )) && ! [[ "${NAMES[j]}" < "${NAMES[j+1]}" ]]; do
    let j-=1
  done
  if (( j < BOTTOM )); then break; fi
  let k=TOP
  while (( k > j )) && [[ "${NAMES[k]}" < "${NAMES[j]}" ]]; do
    let k-=1
  done
  if (( k <= j )); then break; fi
  t="${NAMES[j]}"
  NAMES[j]="${NAMES[k]}"
  NAMES[k]="$t"
  for (( k=1; k<=(TOP-j); ++k )); do
    a=BOTTOM+j+k
    b=TOP-k+1
    if (( a < b )); then
      t="${NAMES[a]}"
      NAMES[a]="${NAMES[b]}"
      NAMES[b]="$t"
    fi
  done
done
