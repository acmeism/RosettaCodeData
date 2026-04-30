class LevenshteinAlignment {
    static alignment(a, b) {
        a = a.toLowerCase();
        b = b.toLowerCase();

        // Initialize costs matrix
        const costs = Array(a.length + 1).fill().map(() => Array(b.length + 1).fill(0));

        // Fill first row and column
        for (let j = 0; j <= b.length; j++) {
            costs[0][j] = j;
        }
        for (let i = 1; i <= a.length; i++) {
            costs[i][0] = i;
            for (let j = 1; j <= b.length; j++) {
                costs[i][j] = Math.min(
                    1 + Math.min(costs[i - 1][j], costs[i][j - 1]),
                    a[i - 1] === b[j - 1] ? costs[i - 1][j - 1] : costs[i - 1][j - 1] + 1
                );
            }
        }

        // Walk back through matrix to figure out path
        let aPathRev = [];
        let bPathRev = [];
        for (let i = a.length, j = b.length; i !== 0 && j !== 0;) {
            if (costs[i][j] === (a[i - 1] === b[j - 1] ? costs[i - 1][j - 1] : costs[i - 1][j - 1] + 1)) {
                aPathRev.push(a[--i]);
                bPathRev.push(b[--j]);
            } else if (costs[i][j] === 1 + costs[i - 1][j]) {
                aPathRev.push(a[--i]);
                bPathRev.push('-');
            } else if (costs[i][j] === 1 + costs[i][j - 1]) {
                aPathRev.push('-');
                bPathRev.push(b[--j]);
            }
        }

        // Reverse and join arrays to form strings
        return [
            aPathRev.reverse().join(''),
            bPathRev.reverse().join('')
        ];
    }
}

// Example usage
const result = LevenshteinAlignment.alignment("rosettacode", "raisethysword");
console.log(result[0]);
console.log(result[1]);
