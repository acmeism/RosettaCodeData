allInputs <- expand.grid(x = 0:(100 %/% 6), y = 0:(100 %/% 9), z = 0:(100 %/% 20))
mcNuggets <- do.call(function(x, y, z) 6 * x + 9 * y + 20 * z, allInputs)
