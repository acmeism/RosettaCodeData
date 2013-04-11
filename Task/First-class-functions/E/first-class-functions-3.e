? def x := 0.5  \
> for i => f in forward {
>     def g := reverse[i]
>     println(`x = $x, f = $f, g = $g, compose($f, $g)($x) = ${compose(f, g)(x)}`)
> }

x = 0.5, f = <sin>, g = <asin>, compose(<sin>, <asin>)(0.5) = 0.5
x = 0.5, f = <cos>, g = <acos>, compose(<cos>, <acos>)(0.5) = 0.4999999999999999
x = 0.5, f = <cube>, g = <curt>, compose(<cube>, <curt>)(0.5) = 0.5000000000000001
