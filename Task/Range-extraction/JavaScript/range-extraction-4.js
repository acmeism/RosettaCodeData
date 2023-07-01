function toRange(arr) {
    const ranges = [];
    const sorted = [...arr.filter(Number.isInteger)].sort((x,y) => Math.sign(x-y));
    const sequenceBreak = (x,y) => y - x > 1 ;

    let i = 0;
    while ( i < sorted.length ) {

        let j = i ;
        while ( j < sorted.length - 1 && !sequenceBreak( sorted[j], sorted[j+1] ) ) {
            ++j;
        }

        const from = sorted[i];
        const thru = sorted[j];
        const rangeLen = 1 + j - i;

        if ( from === thru ) {
            ranges.push( [from] );
        } else {
            if ( rangeLen > 2 ) {
                ranges.push([from,thru]);
            } else {
                ranges.push([from], [thru]);
            }
        }

        i = j+1;
    }

    return ranges.map( range => range.join('-') ).join(',');
}

// -----------------------------------------------------------------------------
// Test Case
// -----------------------------------------------------------------------------
const expected = '0-2,4,6-8,11,12,14-25,27-33,35-39';
const actual = toRange([
     0,  1,  2,
     4,
     6,  7,  8,
    11, 12, // should be two singletons
    14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
    27, 28, 29, 30, 31, 32, 33,
    35, 36, 37, 38, 39,
]);

console.log(`actual output   : '${actual}'.`);
console.log(`expected output : '${expected}'.`);
console.log(`Correct? ${ actual === expected ? 'Yes' : 'No'}`);
