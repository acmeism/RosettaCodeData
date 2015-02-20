   binomialExpansion =:  (!~ * _1 ^ 2 | ]) i.&.:<:         NB. 1) Create a function that gives the coefficients of (x-1)^p.
   testAKS           =:  0 *./ .= ] | binomialExpansion    NB. 3) Use that function to create another which determines whether p is prime using AKS.
