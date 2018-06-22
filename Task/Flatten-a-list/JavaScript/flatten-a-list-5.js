// flatten :: Tree a -> [a]
const flatten = t => Array.isArray(t) ? [].concat(...t.map(flatten)) : t;
