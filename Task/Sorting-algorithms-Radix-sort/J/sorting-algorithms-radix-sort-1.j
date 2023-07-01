radixSortR =: 3 : 0  NB. base radixSort data
16 radixSortR y
:
keys =. x #.^:_1 y NB. compute keys
length =. #{.keys
extra =. (-length) {."0 buckets =. i.x
for_pass. i.-length do.
   keys =. ; (buckets,pass{"1 keys) <@:}./.extra,keys
end.
x#.keys NB. restore the data
)
