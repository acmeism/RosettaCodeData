// Miller primality test for n<3317044064679887385961981. Nigel Galloway: April 1st., 2021
let a=[(2047I,[2I]);(1373653I,[2I;3I]);(9080191I,[31I;73I]);(25326001I,[2I;3I;5I]);(3215031751I,[2I;3I;5I;7I]);(4759123141I,[2I;7I;61I]);(1122004669633I,[2I;13I;23I;1662803I]);
       (2152302898747I,[2I;3I;5I;7I;11I]);(3474749660383I,[2I;3I;5I;7I;11I;13I]);(341550071728321I,[2I;3I;5I;7I;11I;13I;17I]);(3825123056546413051I,[2I;3I;5I;7I;11I;13I;17I;19I;23I]);
       (18446744073709551616I,[2I;3I;5I;7I;11I;13I;17I;19I;23I;29I;31I;37I]);(318665857834031151167461I,[2I;3I;5I;7I;11I;13I;17I;19I;23I;29I;31I;37I]);(3317044064679887385961981I,[2I;3I;5I;7I;11I;13I;17I;19I;23I;29I;31I;37I;41I])]
let rec fN g=function (n:bigint) when n.IsEven->fN(g+1)(n/2I) |n->(n,g)
let rec fG n d r=function a::t->match bigint.ModPow(a,d,n) with g when g=1I || g=n-1I->fG n d r t |g->fL(bigint.ModPow(g,2I,n)) n d t r
                         |_->true
    and fL x n d a=function 1->false |r when x=n-1I->fG n d r a |r->fL(bigint.ModPow(x,2I,n)) n d a (r-1)
let mrP n=let (d,r)=fN 0 (n-1I) in fG n d r (snd(a|>List.find(fst>>(<)n)))

printfn "%A %A" (mrP 2147483647I)(mrP 844674407370955389I)
