> (levenshtein-simple "a" "a")
0
> (levenshtein-simple "a" "")
1
> (levenshtein-simple "" "a")
1
> (levenshtein-simple "kitten" "sitting")
3
