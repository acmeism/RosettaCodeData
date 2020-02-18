// flatten :: NestedList a -> [a]
const flatten = t => {
    const go = x =>
        Array.isArray(x) ? (
            x.flatMap(go)
        ) : x;
    return go(t);
};
