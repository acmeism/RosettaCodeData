[1 8 2 -3 0 1 1 -2.3 0 5.5 8 6 2 9 11 10 3]
| window 2
| group-by { $in.1 - $in.0 | math abs }
| select ($in | columns | math max)
| to nuon
