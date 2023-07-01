julia> perms(l) = isempty(l) ? [l] : [[x; y] for x in l for y in perms(setdiff(l, x))]
