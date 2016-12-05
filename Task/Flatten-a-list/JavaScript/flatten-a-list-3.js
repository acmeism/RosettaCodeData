    // flatten :: Tree a -> [a]
    function flatten(a) {
        return a instanceof Array ? [].concat.apply([], a.map(flatten)) : a;
    }
