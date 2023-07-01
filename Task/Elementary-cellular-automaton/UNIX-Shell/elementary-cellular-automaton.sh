function print_cells {
  local chars=(. '#') cell
  for cell; do
    printf '%s' "${chars[$cell]}"
  done
  printf '\n'
}

function next_gen {
  local rule=$1
  shift
  cells=("$@")
  local -i l c r bit
  for (( l=$#-1, c=0, r=1; c < $#;
         l=(l+1)%$#, c+=1, r=(r+1)%$# )); do
    local left=${cells[l]} current=${cells[c]} right=${cells[r]}
    (( bit = 1<<(left<<2 | current<<1 | right) ))
    printf '%d\n' $(( rule & bit ? 1 : 0 ))
  done
}

function automaton {
  local size=${1:-32} rule=${2:-90}
  local stop=${3:-$(( size/2 ))}
  local i gen cells=()
  for (( i=0; i<size; ++i )); do
    cells+=( $(( i == size/2 )) )
  done
  for (( gen=0; gen<stop; ++gen )); do
    printf "%${#stop}d: " "$gen"
    print_cells "${cells[@]}"
    cells=($(next_gen "$rule" "${cells[@]}"))
  done
}

automaton "$@"
