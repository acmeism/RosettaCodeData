init() {
  if [[ -n $KSH_VERSION ]]; then
    set -A stack
  else
    stack=(); # this sets stack to '()' in ksh
  fi
}

push() {
  stack=("$1" "${stack[@]}")
}

stack_top() {
  # this approach sidesteps zsh indexing difference
  set -- "${stack[@]}"
  printf '%s\n' "$1"
}

pop() {
  stack_top
  stack=("${stack[@]:1}")
}

empty() {
  (( ${#stack[@]} == 0 ))
}

# Demo
push fred; push wilma; push betty; push barney
printf 'peek(stack)==%s\n' "$(stack_top)"
while ! empty; do
  pop
done
