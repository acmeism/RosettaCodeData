// flatten :: NestedList a -> [a]
const flatten = nest =>
    nest.flat(Infinity);
