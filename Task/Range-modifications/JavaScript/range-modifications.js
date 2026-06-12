class Range {
    constructor(low, high) {
        this.low = low;
        this.high = high;
    }

    toString() {
        return `${this.low}-${this.high}`;
    }
}

class Ranges {
    constructor(ranges = []) {
        this.ranges = [...ranges];
    }

    add(n) {
        for (let i = 0; i < this.ranges.length; i++) {
            const current = this.ranges[i];

            if (n + 1 < current.low) {
                this.ranges.splice(i, 0, new Range(n, n));
                return;
            } else if (n + 1 === current.low) {
                current.low = n;
                return;
            } else if (n <= current.high) {
                // No action required - number already in range
                return;
            } else if (n - 1 === current.high) {
                current.high = n;
                // Check if we need to merge with next range
                if (i + 1 < this.ranges.length) {
                    const next = this.ranges[i + 1];
                    if (n === next.low || n + 1 === next.low) {
                        current.high = next.high;
                        this.ranges.splice(i + 1, 1);
                    }
                }
                return;
            } else if (i === this.ranges.length - 1) {
                this.ranges.push(new Range(n, n));
                return;
            }
            // Continue to next iteration if none of the conditions match
        }

        // If we get here, ranges is empty
        this.ranges.push(new Range(n, n));
    }

    remove(n) {
        for (let i = 0; i < this.ranges.length; i++) {
            const current = this.ranges[i];

            if (n === current.low) {
                current.low = n + 1;
                if (current.low > current.high) {
                    this.ranges.splice(i, 1);
                }
                return;
            } else if (n === current.high) {
                current.high = n - 1;
                if (current.high < current.low) {
                    this.ranges.splice(i, 1);
                }
                return;
            } else if (n > current.low && n < current.high) {
                const high = current.high;
                current.high = n - 1;
                this.ranges.splice(i + 1, 0, new Range(n + 1, high));
                return;
            }
        }
    }

    toString() {
        return `[${this.ranges.join(', ')}]`;
    }
}

// Helper functions for display
function displayAdd(ranges, n) {
    ranges.add(n);
    console.log(`       add ${n.toString().padStart(2)} => ${ranges}`);
}

function displayRemove(ranges, n) {
    ranges.remove(n);
    console.log(`    remove ${n.toString().padStart(2)} => ${ranges}`);
}

// Main execution
function main() {
    let ranges = new Ranges([]);
    console.log("Initial ranges = " + ranges);
    displayAdd(ranges, 77);
    displayAdd(ranges, 79);
    displayAdd(ranges, 78);
    displayRemove(ranges, 77);
    displayRemove(ranges, 78);
    displayRemove(ranges, 79);

    ranges = new Ranges([new Range(1, 3), new Range(5, 5)]);
    console.log("\nInitial ranges = " + ranges);
    displayAdd(ranges, 1);
    displayRemove(ranges, 4);
    displayAdd(ranges, 7);
    displayAdd(ranges, 8);
    displayAdd(ranges, 6);
    displayRemove(ranges, 7);

    ranges = new Ranges([new Range(1, 5), new Range(10, 25), new Range(27, 30)]);
    console.log("\nInitial ranges = " + ranges);
    displayAdd(ranges, 26);
    displayAdd(ranges, 9);
    displayAdd(ranges, 7);
    displayRemove(ranges, 26);
    displayRemove(ranges, 9);
    displayRemove(ranges, 7);
}

// Run the main function
main();
