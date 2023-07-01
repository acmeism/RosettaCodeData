# pop ARRAY -- pop the last item on ARRAY and output it

pop() {
  local var=${1:?'Missing array name'}
  local x ;   eval "x=\${#$var[*]}"
  if [[ $x > 0 ]]; then
    local val ; eval "val=\"\${$var[$((--x))]}\""
    unset $var[$x]
  else
    echo 1>&2 "No items in $var" ; exit 1
  fi
  echo "$val"
}

alist=(a b c)
pop alist
a
pop alist
b
pop alist
c
pop alist
No items in alist
