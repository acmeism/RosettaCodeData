COLORS=(red white blue)

# to go from name to number, we make variables out of the color names (e.g. the
# variable "$red" has value "1").
for (( i=0; i<${#COLORS[@]}; ++i )); do
  eval ${COLORS[i]}=$i
done

# Make a random list
function random_balls {
  local -i n="$1"
  local -i i
  local balls=()
  for (( i=0; i < n; ++i )); do
    balls+=("${COLORS[RANDOM%${#COLORS[@]}]}")
  done
  echo "${balls[@]}"
}

# Test for Dutchness
function dutch? {
  if (( $# < 2 )); then
     return 0
  else
    local first="$1"
    shift
    if eval "(( $first > $1 ))"; then
      return 1
    else
      dutch? "$@"
    fi
  fi
}

# Sort into order
function dutch {
  local -i lo=-1 hi=$# i=0
  local a=("$@")
  while (( i < hi )); do
    case "${a[i]}" in
      red)
        let lo+=1
        local t="${a[lo]}"
        a[lo]="${a[i]}"
        a[i]="$t"
        let i+=1
        ;;
      white) let i+=1;;
      blue)
        let hi-=1
        local t="${a[hi]}"
        a[hi]="${a[i]}"
        a[i]="$t"
        ;;
    esac
  done
  echo "${a[@]}"
}
