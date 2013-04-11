#!/bin/sh

matched() {
	egrep "$1" unixdict.txt | wc -l
}

check() {
	if [ $(expr $(matched $3) \> $(expr 2 \* $(matched $2))) = '0' ]; then
		echo clause $1 not plausible
		exit 1
	fi
}

check 1 \[^c\]ei \[^c\]ie && check 2 cie cei && echo plausible
