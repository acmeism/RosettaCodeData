open 'unixdict.txt' | split chars | where $it =~ '^\pL$' | uniq -c | sort
