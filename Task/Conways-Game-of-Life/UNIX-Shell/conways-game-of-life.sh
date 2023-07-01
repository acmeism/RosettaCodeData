# Shells only have 1-dimensional arrays, so each row is one string
function main {
  typeset blinker=(000 111 000)
  run list 4 "${blinker[@]}"
}

function run {
  typeset mode=$1 # screen or list
  shift
  typeset -i limit=0
  if (( $1 > 1 )); then
    limit=$1
    shift
  fi
  if [[ mode == screen ]]; then
    clear
  fi
  typeset universe=("$@")
  typeset -i generation=0
  while (( !limit || generation < limit )); do
    if [[ mode == screen ]]; then
      printf '\e[H'
    else
      printf '\n'
    fi
    printf 'Generation %d\n' "$generation"
    disp "${universe[@]}" | tr '01' '.@'
    universe=($(next_generation "${universe[@]}"))
    (( generation += 1 ))
    sleep 0.125
  done
}

# display a matrix
function disp {
  # remove sed for more compact display
  printf '%s\n' "$@" | sed 's/./ &/g'
}

# center a matrix within a given size by padding with 0s
function center {
  typeset height=$1 width=$2
  shift 2
  typeset -i offset_i offset_j i j
  if (( $# > height || ${#1} > width )); then
    printf >&2 'Source larger than target.\n'
    return 1
  fi
  (( offset_i = (height - $#) / 2 ))
  (( offset_j = (width - ${#1}) / 2 ))
  typeset prefix zeroes suffix
  for (( j=0; j<width; ++j )); do
    zeroes+=0
    if (( j < offset_j )); then
      prefix+=0
    elif (( j >= offset_j+${#1} )); then
      suffix+=0
    fi
  done
  for (( i=0; i<offset_i; ++i )); do
    printf '%s\n' "$zeroes"
  done
  while (( $# )); do
    printf '%s%s%s\n' "$prefix" "$1" "$suffix"
    shift
    (( i++ ))
  done
  while (( i++ < height )); do
    printf '%s\n' "$zeroes"
  done
}

# compute the next generation
# the grid is finite; pass -t to treat as torus (wraparound), otherwise it's
# bounded by always-dead cells
next_generation() {
  typeset -i torus=0
  if [[ $1 == -t ]]; then
    torus=1
    shift
  fi
  # cache cells in an associative array
  # (for fast lookup when counting neighbors)
  typeset -A cells
  typeset -i i=0 j=0 height=$# width=${#1}
  while (( $# )); do
    row=$1
    shift
    for (( j=0; j<${#row}; ++j )); do
      cells[$i,$j]=${row:$j:1}
    done
    (( i+=1 ))
  done
  typeset -i di dj ni nj n cell
  for (( i=0; i<height; ++i )); do
    for (( j=0; j<width; ++j )); do
      n=0
      for (( di=-1; di<2; ++di )); do
        (( ni = i + di ))
        if (( torus )); then
          (( ni = (ni + height) % height ))
        fi
        for (( dj=-1; dj<2; ++dj )); do
          (( nj = j + dj ))
          if (( torus )); then
            (( nj = (nj + width) % width ))
          fi
          if (( (di || dj) && ni >= 0 && nj >= 0 && ni < height && nj < width  )); then
            (( n += ${cells[$ni,$nj]} ))
          fi
        done
      done
      printf '%d' "$(( ( n == 3 ) || ( ${cells[$i,$j]} && n==2 ) ))"
    done
    printf '\n'
  done
}

main "$@"
