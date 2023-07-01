add_curry <- curry(`+`)
add2 <- add_curry(2)
add2(40)
uncurry(add_curry)(40, 2)
