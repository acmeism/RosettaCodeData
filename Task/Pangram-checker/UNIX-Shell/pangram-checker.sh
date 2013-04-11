function pangram? {
  local alphabet=abcdefghijklmnopqrstuvwxyz
  local string="$*"
  string="${string,,}"
  while [[ -n "$string" && -n "$alphabet" ]]; do
    local ch="${string%%${string#?}}"
    string="${string#?}"
    alphabet="${alphabet/$ch}"
  done
  [[ -z "$alphabet" ]]
}
