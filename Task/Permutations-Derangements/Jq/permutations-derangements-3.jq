$ jq -n -c -r -f derangements.jq

Derangements:
[2,1,4,3]
[2,3,4,1]
[2,4,1,3]
[3,1,4,2]
[3,4,1,2]
[3,4,2,1]
[4,1,2,3]
[4,3,1,2]
[4,3,2,1]

Counted vs Computed Derangments:
1: 0 vs 0
2: 1 vs 1
3: 2 vs 2
4: 9 vs 9
5: 44 vs 44
6: 265 vs 265
7: 1854 vs 1854
8: 14833 vs 14833
9: 133496 vs 133496

Computed approximation to !20 (15 significant digits): 895014631192902000
