const symmetricDifference = (...args) => {
    let result = new Set();
    for (const x of args)
        for (const e of new Set(x))
            if (result.has(e)) result.delete(e)
    		else result.add(e);

    return [...result];
}
 // TEST -------------------------------------------------------------------
console.log(symmetricDifference(["Jim", "Mary", "John", "Jim", "Bob"],["John", "Serena", "Bob", "Mary", "Serena"]));
console.log(symmetricDifference([1, 2, 5], [2, 3, 5], [3, 4, 5]));
