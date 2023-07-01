perl -n -e '/(\S+)\s*$/ and $1 > 6 and print' data.txt
