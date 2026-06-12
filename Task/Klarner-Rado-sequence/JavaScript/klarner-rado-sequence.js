/**
 * Generates the Klarner-Rado sequence up to a given limit.
 * The sequence starts with 1, and subsequent elements are generated
 * by applying the rules 2*x + 1 and 3*x + 1 to existing elements,
 * keeping the results sorted and unique.
 *
 * @param {number} limit The number of elements to generate (sequence length).
 * @returns {number[]} An array containing the Klarner-Rado sequence.
 *                     The array is 1-indexed for consistency with the C++ example
 *                     (index 0 is unused).
 */
function initialiseKlarnerRadoSequence(limit) {
    // Use a standard JavaScript array. Indices start at 0, but we'll
    // follow the C++ logic and populate from index 1.
    const result = new Array(limit + 1);

    // Use 'let' as these indices and values will change.
    let i2 = 1;
    let i3 = 1;
    let m2 = 1; // Next potential value from the 2*x + 1 rule (starting with x=0 -> 1, but the sequence generation uses previous *elements*)
                // Actually, starts with result[i2] = result[1]... but result[1] isn't set yet.
                // The logic implicitly starts with 1 as the base case.
                // Let's trace: i=1 -> min(1,1)=1. result[1]=1.
                // if m2==1: m2 = result[1]*2+1 = 1*2+1 = 3. i2=2.
                // if m3==1: m3 = result[1]*3+1 = 1*3+1 = 4. i3=2.
                // Correct initialization seems to be m2=1, m3=1 as per C++.

    let m3 = 1;

    // Start loop from 1 to match C++ logic and 1-based sequence indexing
    for (let i = 1; i <= limit; ++i) {
       // Find the minimum of the next potential candidates
       const minimum = Math.min(m2, m3);
       result[i] = minimum;

       // If the minimum came from the 2*x + 1 rule, generate the next
       // candidate using the next element from the sequence for that rule.
       // IMPORTANT: Use === for strict equality comparison in JS.
       if (m2 === minimum) {
          // result[i2] is the element that generated the current m2
          m2 = result[i2] * 2 + 1;
          i2++;
       }

       // If the minimum came from the 3*x + 1 rule, generate the next
       // candidate using the next element from the sequence for that rule.
       // NOTE: This is NOT an else-if. If m2 == m3, both need to advance.
       if (m3 === minimum) {
          // result[i3] is the element that generated the current m3
          m3 = result[i3] * 3 + 1;
          i3++;
       }
    }
    return result;
}

// --- Main execution part (equivalent to C++ main) ---

// Use numeric separators for readability (like C++ 1'000'000)
const limit = 1000000;
const klarnerRado = initialiseKlarnerRadoSequence(limit);

console.log("The first 100 elements of the Klarner-Rado sequence:");

// Build the formatted output string for the first 100 elements
let outputString = "";
for (let i = 1; i <= 100; ++i) {
    // Use String.padStart() for formatting (equivalent to setw)
    // Convert number to string before padding. Pad with spaces to width 3.
    outputString += String(klarnerRado[i]).padStart(3, ' ');

    // Add a newline every 10 elements, otherwise add a space
    if (i % 10 === 0) {
        outputString += "\n";
    } else {
        outputString += " ";
    }
}
// Print the formatted block
console.log(outputString.trimEnd()); // trimEnd to remove trailing space if count not multiple of 10
console.log(); // Add an extra newline like the C++ code

let index = 1000;
while (index <= limit) {
    // Use template literals for easy string interpolation
    console.log(`The ${index}th element of Klarner-Rado sequence is ${klarnerRado[index]}`);
    index *= 10;
}
