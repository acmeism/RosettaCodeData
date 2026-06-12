#!/bin/bash

# This option will make the script exit when there is an error
set -o errexit
# This option will make the script exit when it tries to use an unset variable
set -o nounset

declare -A grid
declare -A cell_type=(
  ["empty"]=0 ["barrier"]=1
  ["start"]=2 ["end"]=3
  ["path"]=4
  ["right"]=5     ["left"]=6
  ["up"]=7        ["down"]=8
  ["left_up"]=9   ["left_down"]=10
  ["right_up"]=11 ["right_down"]=12
  )
grid_size=(10 10)

generate_rosetta_grid(){
  grid_size=(8 8)
  start=(0 0)
  end=(7 7)
  for (( i = 0; i < grid_size[0]; i++ )); do
    for (( j = 0; j < grid_size[1]; j++ )); do
      grid[$i,$j]=${cell_type[empty]}
    done
  done
  barriers=( "2,4" "2,5" "2,6" "3,6" "4,6" "5,6" "5,5" "5,4" "5,3" "5,2" "4,2" "3,2")
  for barrier in ${barriers[*]};do
    grid["$barrier"]=${cell_type[barrier]}
  done
  grid[${start[0]},${start[1]}]=${cell_type[start]}
  grid[${end[0]},${end[1]}]=${cell_type[end]}
}

abs(){
  # Number absolute value.
  # Params:
  # ------
  # $1 -> number
  # Return:
  # number abs
  if [[ $1 -gt 0 ]];
  then
    echo "$1"
  else
    echo "$((-$1))"
  fi
}

print_table(){
  # Print table using unicode symbols.
  # Symbols:
  # " " -> empty cell
  # ◼ -> barrier
  # ◉ -> start position
  # ✪ -> goal
  # arrows -> path from start to goal
  printf ' '
  # Print letters at top.
  for ((i=0;i< grid_size[1];i++)) do
      printf "%s" $i
  done
  echo
  for ((i=0;i < grid_size[0];i++)) do
      # Print numbers.
      printf "%s" $i
      for ((j=0;j < grid_size[1];j++)) do
          cell=${grid[$i,$j]}
          if [[ $cell  -eq ${cell_type[empty]} ]];
          then
            # If cell is empty prints space
            printf " "
          elif [[ $cell -eq ${cell_type[barrier]} ]]; then
            # If cell is a barrier
            printf "■"
          elif [[ $cell -eq ${cell_type[start]} ]]; then
            # Print start and end position
            printf "◉"
          elif [[ $cell -eq ${cell_type[end]} ]]; then
            # Print end position
            printf "✪"
          elif [[ $cell -eq ${cell_type[path]} ]]; then
            # Print path
            printf "*"
          elif [[ $cell -eq ${cell_type[up]} ]]; then
            # Print path
            printf "↑"
          elif [[ $cell -eq ${cell_type[down]} ]]; then
            # Print path
            printf "↓"
          elif [[ $cell -eq ${cell_type[right]} ]]; then
            # Print path
            printf "→"
          elif [[ $cell -eq ${cell_type[left]} ]]; then
            # Print path
            printf "←"
          elif [[ $cell -eq ${cell_type[right_up]} ]]; then
            # Print path
            printf "↗"
          elif [[ $cell -eq ${cell_type[right_down]} ]]; then
            # Print path
            printf "↙"
          elif [[ $cell -eq ${cell_type[left_up]} ]]; then
            # Print path
            printf "↖"
          elif [[ $cell -eq ${cell_type[left_down]} ]]; then
            # Print path
            printf "↘"
          fi
      done
      echo
  done
}

get_neighbours(){
  # Calculates all point's neighbours
  # Params:
  # ------
  # $1 -> "x,y" formatted point position
  # Return:
  # ------
  # array of available positions
  # Skips nonexistent indices.

  neighbours=()
  for i in {-1..1},{-1..1}; do
    if [[ ( ${i%,*} -eq 0 ) && ( ${i#*,} -eq 0 ) ]]; then
      continue
    fi
    dx=${i%,*}
    dy=${i#*,}
    x=$((${1%,*}+dx))
    y=$((${1#*,}+dy))
    if [[ $x -lt 0 ]] || [[ $x -ge ${grid_size[0]} ]];
    then
      continue
    fi
    if [[ $y -lt 0 || $y -ge ${grid_size[1]} ]];
    then
      continue
    fi
    neighbours+=("$x,$y")
  done
  echo "${neighbours[*]}"
}


move_cost(){
  # Calculates how much will it cost
  # to travel to point b.
  # return 100 if b is barrier
  #
  # Params:
  # ------
  # $1 -> a
  # $2 -> b
  # Return:
  # ------
  # movement cost.

  barrier=${cell_type[barrier]}
  if [[ ${grid[${2%,*},${2#*,}]} -eq barrier ]];
  then
    echo 100
  else
    echo 1
  fi
}

print_raw(){
  # Print raw grid values.

  for ((i=0;i < grid_size[0];i++)) do
      for ((j=0;j < grid_size[1];j++)) do
        printf "%s" "${grid[$i,$j]}"
      done
      echo
  done
}

minimum(){
  # Minimum between two numbers
  # Params:
  # ------
  # $1 -> a
  # $2 -> b
  # Return:
  # ------
  # less value

  if [[ $1 -lt $2 ]];
  then
    echo "$1"
  else
    echo "$2"
  fi
}

heuristic_cost(){
  # Chebyshev distance heuristic score
  # if we can move one square either
  # adjacent or diagonal

  d=1
  d2=1
  dx=$(abs $((${1#*,} - ${2#*,})))
  dy=$(abs $((${1%,*} - ${2%,*})))
  echo "$(((d*(dx + dy))+(d2 - 2 * d)*$(minimum dx dy)))"
}

contains(){

  for el in "${2[@]}"; do
    echo "$el"
  done
}

contains_value() {
    # Check if element exists in array
    # Params:
    # ------
    # $1 -> array
    # $2 -> element to find.
    # Returns:
    # 1 if element exists in array
    # 0 otherwise.

    local array="$1[@]"
    arr=("${!array}")
    local seeking=$2
    local in=0
    for element in ${arr[*]}; do
        if [ "$element" = "$seeking" ]; then
            in=1
            break
        fi
    done
    echo "$in"
}

reverse_array(){
  # Reverse given array.
  # Params:
  # ------
  # $1 -> array
  # Return:
  # ------
  # reversed array.
  local array="$1[@]"
  arr=("${!array}")
  result=()
  for (( idx=${#arr[@]}-1 ; idx>=0 ; idx-- )) ; do
    result+=("${arr[$idx]}")
  done
  echo "${result[@]}"
}


find_path(){
  declare -A fScore
  declare -A gScore
  declare -A cameFrom
  declare -a openVertices
  declare -a closedVertices
  for (( i = 0; i < grid_size[0]; i++ )); do
    for (( j = 0; j < grid_size[1]; j++ )); do
      gScore[$i,$j]=$((1<<62))
      fScore[$i,$j]=$((1<<62))
    done
  done
  gScore["${start[0]},${start[1]}"]=0
  fScore["${start[0]},${start[1]}"]=$(heuristic_cost "${start[0]},${start[1]}" "${end[0]},${end[1]}")
  openVertices+=("${start[0]},${start[1]}")

  while [[ -n "${openVertices[*]}" ]]; do

    current=-1
    currentFscore=0
    for pos in ${openVertices[*]}; do
      if [[  $current -eq -1 ]] ||
         [[ ${fScore["$pos"]} -lt $currentFscore ]]; then
        currentFscore=${fScore["$pos"]}
        current=$pos
      fi
    done
    if [[ "$current" = "${end[0]},${end[1]}" ]]; then
      path=( "$current" )
      while [ ${cameFrom["$current"]+_} ]; do
        current=${cameFrom["$current"]}
        path+=("$current")
      done
      reverse_array path
      return 0
    fi
    openVertices=( "$( echo "${openVertices[@]/$current}" | xargs )" )
    closedVertices+=( "$current" )
    neighbours=( "$(get_neighbours "$current")" )

    for neighbour in ${neighbours[*]}; do
      if [[ $(contains_value closedVertices "$neighbour") -eq 1 ]]; then
        continue
      fi
      mCost="$(move_cost "$current" "$neighbour")"
      candidateG=$(( ${gScore["$current"]}+mCost ))
      if [[ $candidateG -gt 100 ]]; then
        continue
      fi
      if [[  $(contains_value openVertices "$neighbour") -eq 0 ]]; then
        openVertices+=("$neighbour")
      elif [[ $candidateG -gt ${gScore[$neighbour]} ]]; then
        continue
      fi
      cameFrom["$neighbour"]="$current"
      gScore["$neighbour"]=$candidateG
      heuristic_score=$(heuristic_cost "$neighbour" "${end[0]},${end[1]}")
      fScore["$neighbour"]=$(( candidateG+heuristic_score ))
    done
  done
}

map_to_arrows(){
  local array="$1[@]"
  arr=("${!array}")
  last="${start[0]},${start[1]}"
  for el in ${arr[*]}; do
    if   [[ $((${el#*,}-${last#*,})) -eq -1 ]] &&
         [[ $((${el%,*}-${last%,*})) -eq -1 ]]; then
      grid["$last"]=${cell_type[left_up]}
    elif [[ $((${el#*,}-${last#*,})) -eq -1 ]] &&
         [[ $((${el%,*}-${last%,*})) -eq 1 ]]; then
           grid["$last"]=${cell_type[right_down]}
    elif [[ $((${el#*,}-${last#*,})) -eq 1 ]] &&
         [[ $((${el%,*}-${last%,*})) -eq -1 ]]; then
      grid["$last"]=${cell_type[right_up]}
    elif [[ $((${el#*,}-${last#*,})) -eq 1 ]] &&
         [[ $((${el%,*}-${last%,*})) -eq 1 ]]; then
      grid["$last"]=${cell_type[left_down]}
    elif [[ $((${el#*,}-${last#*,})) -eq -1 ]];then
      grid["$last"]=${cell_type[left]}
    elif [[ $((${el%,*}-${last%,*})) -eq -1 ]];then
      grid["$last"]=${cell_type[up]}
    elif [[ $((${el#*,}-${last#*,})) -eq 1 ]];then
      grid["$last"]=${cell_type[right]}
    elif [[ $((${el%,*}-${last%,*})) -eq 1 ]];then
      grid["$last"]=${cell_type[down]}
    else
      grid["$last"]=${cell_type[path]}
    fi
    last=$el
  done
  grid[${start[0]},${start[1]}]=${cell_type[start]}
  grid[${end[0]},${end[1]}]=${cell_type[end]}
}


main(){
  generate_rosetta_grid
  path=( "$(find_path)" )
  pstr="$(echo "${path[*]}" | xargs | sed "s/[[:space:]]/ → /g")"
  echo path: "$pstr"
  if [[ -z $pstr ]]; then
    echo "No path found."
  else
    map_to_arrows path
    print_table
  fi
}

main "$@"

