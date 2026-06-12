open 'unixdict.txt' | split words -l 6 | where $it ends-with ($it | str substring ..2)
