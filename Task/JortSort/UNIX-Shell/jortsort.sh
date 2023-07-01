JortSort() {
   cmp -s <(printf “%s\n” “$@“) <(printf “%s\n” “$@“ | sort)
}

JortSortVerbose() {
  if JortSort “$@“; then
    echo True
  else
    echo False
  If
}

JortSortVerbose 1 2 3 4 5
JortSortVerbose 1 3 4 5 2
JortSortVerbose a b c
JortSortVerbose c a b
