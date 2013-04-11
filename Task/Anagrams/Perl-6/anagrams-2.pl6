slurp('unixdict.txt')\
.words\
.classify( *.comb.sort.join )\
.classify( +*.value )\
.sort( -*.key )[0]\
.value\
.values\
».value\
».say
