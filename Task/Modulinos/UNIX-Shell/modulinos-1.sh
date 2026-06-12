#!/usr/bin/env sh

meaning_of_life() {
	return 42
}

main() {
	meaning_of_life
	echo "Main: The meaning of life is $?"
}

if [[ "$BASH_SOURCE" == "$0" ]]
then
    main
fi
