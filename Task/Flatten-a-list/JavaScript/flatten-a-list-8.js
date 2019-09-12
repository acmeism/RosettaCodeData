// flatten :: Nested List a -> a
const flatten = t => {
    let xs = t;
    while (xs.some(Array.isArray)) (
        xs = [].concat(...xs)
    )
    return xs;
};
