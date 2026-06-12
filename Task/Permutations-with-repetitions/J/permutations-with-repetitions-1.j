   Found=: 0 1 1&-:  NB. sample early termination point
   v=: {{
a=.(x#~#y)#:1+x#.y   NB. generate next n-permutation
1 Z:*./a=<:x         NB. quit if we've exhausted all n-perms
a [1 Z:Found a       NB. pass to external verb to decide whether we're done
}}
   pr=: ] ]F:v [#0:  NB. permutations w/ repetition
   3 pr 4            NB. generate n-perms until target seq is found
0 0 1
0 0 2
0 0 3
0 1 0
0 1 1
