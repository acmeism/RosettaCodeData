function jaccardIndex(A, B) {
    // Create sets from the arrays to handle duplicates and enable set operations
    const setA = new Set(A);
    const setB = new Set(B);

    // Calculate intersection
    const intersection = new Set([...setA].filter(x => setB.has(x)));

    // Calculate union
    const union = new Set([...setA, ...setB]);

    const i = intersection.size;
    const u = union.size;

    // Handle edge cases: empty union returns 1.0, empty intersection returns 0.0
    return u === 0 ? 1.0 : i === 0 ? 0.0 : i / u;
}

function main() {
    const tests = [
        [],
        [1, 2, 3, 4, 5],
        [1, 3, 5, 7, 9],
        [2, 4, 6, 8, 10],
        [2, 3, 5, 7],
        [8]
    ];

    console.log("     Set A              Set B         J(A, B)");
    console.log("---------------------------------------------");

    for (const a of tests) {
        for (const b of tests) {
            const aStr = JSON.stringify(a).padEnd(19);
            const bStr = JSON.stringify(b).padEnd(19);
            const jaccardStr = jaccardIndex(a, b).toFixed(5);
            console.log(`${aStr}${bStr}${jaccardStr}`);
        }
    }
}

// Run the main function
main();
