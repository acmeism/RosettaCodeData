import Data.List (permutations)
main = print [ (b,c,f,m,s) | [b,c,f,m,s] <- permutations [1..5], b/=5,c/=1,f/=1,f/=5,m>c,abs(s-f)>1,abs(c-f)>1]
