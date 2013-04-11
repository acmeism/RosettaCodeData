fun subsets xs = foldr (fn (x, rest) => rest @ map (fn ys => x::ys) rest) [[]] xs
