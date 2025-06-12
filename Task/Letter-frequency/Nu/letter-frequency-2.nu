open 'unixdict.txt' | split chars | where $it =~ '^\pL$' | histogram
