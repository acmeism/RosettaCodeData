init_stack() {
  if [[ -n $KSH_VERSION ]]; then
    eval 'set -A '"$1"
  else
    eval "$1=()"
  fi
}

push() {
  eval "$1"'=("$2" "${'"$1"'[@]}")'
}

stack_top() {
  eval 'set -- "${'"$1"'[@]}"';
  printf '%s\n' "$1"
}

pop() {
  stack_top "$1";
  eval "$1"'=("${'"$1"'[@]:1}")'
}

empty() {
  eval '(( ${#'"$1"'[@]} == 0 ))'
}

init_stack mystack
push mystack fred; push mystack wilma; push mystack betty; push mystack barney
printf 'peek(mystack)==%s\n' "$(stack_top mystack)"
while ! empty mystack; do
  pop mystack
done
