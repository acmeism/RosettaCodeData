> :t fs
fs :: [b -> Integer]
> map ($ ()) fs
[1,4,9,16,25,36,49,64,81,100]
> fs !! 9 $ ()
100
> fs !! 8 $ undefined
81
