: compose(f, g)   #[ g perform f perform ] ;

[ #cos, #sin, #[ 3 pow ] ] [ #acos, #asin, #[ 3 inv powf ] ] zipWith(#compose)
map(#[ 0.5 swap perform ]) conform(#[ 0.5 == ]) println
