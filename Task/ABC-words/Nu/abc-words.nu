open 'unixdict.txt' | split words | where $it =~ '(?i)^[^abc]*a[^bc]*b[^c]*c'
