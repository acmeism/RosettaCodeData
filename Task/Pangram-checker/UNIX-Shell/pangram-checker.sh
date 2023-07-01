function is_pangram {
  typeset alphabet=abcdefghijklmnopqrstuvwxyz
  typeset -l string=$*
  while [[ -n $string && -n $alphabet ]]; do
    typeset ch=${string%%${string#?}}
    string=${string#?}
    alphabet=${alphabet/$ch}
  done
  [[ -z $alphabet ]]
}
