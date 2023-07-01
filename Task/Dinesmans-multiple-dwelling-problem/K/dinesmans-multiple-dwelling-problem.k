perm: {x@m@&n=(#?:)'m:!n#n:#x}
filter: {y[& x'y]}
reject: {y[& ~x'y]}
adjacent: {1 = _abs (z?x) - (z?y)}

p: perm[`Baker `Cooper `Fletcher `Miller `Smith]
p: reject[{`Cooper=x[0]}; p]
p: reject[{`Baker=x[4]}; p]
p: filter[{(x ? `Miller) > (x ? `Cooper)}; p]
p: reject[{adjacent[`Smith; `Fletcher; x]}; p]
p: reject[{adjacent[`Cooper; `Fletcher; x]}; p]
p: reject[{(x ? `Fletcher)_in (0 4)}; p]
