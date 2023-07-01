2006 | taxicabs as $t
| (range(0;25), range(1999;2006)) as $i
| "\($i+1): \($t[$i][0]) ~ \($t[$i][1]) and \($t[$i][2])"
