> (levenshtein-distance "a" "a")
0
> (levenshtein-distance "a" "")
1
> (levenshtein-distance "" "a")
1
> (levenshtein-distance "kitten" "sitting")
3
> (levenshtein-distance "rosettacode" "raisethysword")
8
