# List of abbreviated compass point labels
compass_points=( N NbE N-NE NEbN NE NEbE E-NE EbN
                 E EbS E-SE SEbE SE SEbS S-SE SbE
                 S SbW S-SW SWbS SW SWbW W-SW WbS
                 W WbN W-NW NWbW NW NWbN N-NW NbW )

# List of angles to test
test_angles=(  0.00  16.87  16.88  33.75  50.62  50.63  67.50
              84.37  84.38 101.25 118.12 118.13 135.00 151.87
             151.88 168.75 185.62 185.63 202.50 219.37 219.38
             236.25 253.12 253.13 270.00 286.87 286.88 303.75
             320.62 320.63 337.50 354.37 354.38 )


# capitalize a string
function capitalize {
  echo "$1" | sed 's/^./\U&/'
}

# convert compass point abbreviation to full text of label
function expand_point {
  local label="$1"
  set -- N north E east S south W west b " by "
  while (( $# )); do
    label="${label//$1/$2}"
    shift 2
  done
  capitalize "$label"
}

# modulus function that returns 1..N instead of 0..N-1
function amod {
  echo $(( ($1 - 1) % $2 + 1 ))
}

# convert a compass angle from degrees into a box index (1..32)
function compass_point {
  #amod $(dc <<<"$1 5.625 + 11.25 / 1 + p") 32
  amod $(bc <<<"($1 + 5.625) / 11.25 + 1") 32
}

#  Now output the table of test data
header_format="%-7s | %-18s | %s\n"
row_format="%7.2f | %-18s | %2d\n"
printf "$header_format" "Degrees" "Closest Point" "Index"
for angle in ${test_angles[@]}; do
  let index=$(compass_point $angle)
  abbr=${compass_points[index-1]}
  label="$(expand_point $abbr)"
  printf "$row_format" $angle "$label" $index
done
