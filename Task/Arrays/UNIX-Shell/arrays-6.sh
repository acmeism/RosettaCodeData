# shell function to append values to an array
# push LIST VALUES ...
push() {
  local var=${1:?'Missing variable name!'}
  shift
  eval "\$$var=( \"\${$var[@]}\" \"$@\" )"
}

push alist "one thing to add"
push alist many words to add
