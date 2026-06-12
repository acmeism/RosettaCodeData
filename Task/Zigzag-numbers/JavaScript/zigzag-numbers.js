/**
 * Check if the array has the zigzag property
 */
function isZigzag(arr) {
    if (!arr || arr.length < 2) {
        return true;
    }

    for (let i = 0; i < arr.length - 1; i++) {
        if (i % 2 === 0) { // even index i
            if (arr[i] >= arr[i + 1]) {
                return false;
            }
        } else { // odd index i
            if (arr[i] <= arr[i + 1]) {
                return false;
            }
        }
    }
    return true;
}

/**
 * Mutates arr into the next permutation with the zigzag property.
 * Returns true if a new permutation was found, otherwise false.
 */
function nextZigzagPerm(arr) {
    while (true) {
        if (!arr || arr.length <= 1) {
            break;
        }

        // Find last index where arr[i] < arr[i+1]
        let i = -1;
        for (let idx = 0; idx < arr.length - 1; idx++) {
            if (arr[idx] < arr[idx + 1]) {
                i = idx;
            }
        }

        if (i === -1) {
            // Reverse the array
            reverseArray(arr, 0, arr.length - 1);
            break;
        }

        // Find last index where arr[j] > arr[i]
        let j = i + 1;
        for (let idx = i + 1; idx < arr.length; idx++) {
            if (arr[idx] > arr[i]) {
                j = idx;
            }
        }

        // Swap elements at i and j
        swap(arr, i, j);

        // Reverse the subarray from i+1 to end
        reverseArray(arr, i + 1, arr.length - 1);

        if (isZigzag(arr)) {
            return true;
        }
    }
    return false;
}

/**
 * Helper method to swap two elements in an array
 */
function swap(arr, i, j) {
    const temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
}

/**
 * Helper method to reverse a portion of an array
 */
function reverseArray(arr, start, end) {
    while (start < end) {
        swap(arr, start, end);
        start++;
        end--;
    }
}

/**
 * Lazy iterator to generate zigzag permutations of length n
 */
class Zigzags {
    constructor(n) {
        this.n = n;
        this.state = Array.from({ length: n }, (_, i) => i + 1);
        this.hasNext = true;
    }

    [Symbol.iterator]() {
        return this;
    }

    next() {
        if (!this.hasNext) {
            throw new Error("No more elements");
        }

        const result = [...this.state];
        this.hasNext = nextZigzagPerm(this.state);
        return { value: result, done: !this.hasNext };
    }
}

/**
 * Generate zigzag permutation listings and print totals.
 */
function testZigzags(nListings, nTotals) {
    // Generate zigzag permutation listings
    for (let n = 1; n <= nListings; n++) {
        console.log(`\nZigZag Permutations for N = ${n}:`);
        if (n < 3) {
            console.log(`[${Array.from({ length: n }, (_, i) => i + 1).join(", ")}]`);
        } else {
            const zigzags = new Zigzags(n);
            let result = zigzags.next();
            while (!result.done) {
                console.log(`[${result.value.join(", ")}] `);
                result = zigzags.next();
            }
        }
    }

    // Calculate and print totals
    let zzn = [1n];

    console.log("\nN     Zigzags");
    console.log("--------------------------------");
    console.log(" 1    1");

    for (let m = 1; m < nTotals; m++) {
        const cumsum = [];
        let total = 0n;

        if (m % 2 === 0) {
            // Reverse iteration
            for (let i = zzn.length - 1; i >= 0; i--) {
                total += zzn[i];
                cumsum.push(total);
            }
            cumsum.reverse();
            zzn = [...cumsum, 0n];
        } else {
            for (const x of zzn) {
                total += x;
                cumsum.push(total);
            }
            zzn = [0n, ...cumsum];
        }

        const sum = zzn.reduce((acc, val) => acc + val, 0n);
        console.log(`${(m + 1).toString().padStart(2)}    ${sum.toString()}`);
    }
}

// Run the test
testZigzags(5, 30);

