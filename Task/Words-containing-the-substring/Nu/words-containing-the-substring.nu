open 'unixdict.txt' | split words -l 12 | where ('the' in $it)
