# borrowed from github.com/search?q=bashnative

rand() {
	printf $((  $1 *  RANDOM  / 32767   ))
}
rand_element () {
    local -a th=("$@")
    unset th[0]
    printf $'%s\n' "${th[$(($(rand "${#th[*]}")+1))]}"
}

echo "You feel like a $(rand_element pig donkey unicorn eagle) today"
