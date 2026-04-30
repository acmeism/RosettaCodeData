// Calculate and show here the first 10 members of EKG[2], EKG[5], EKG[7], EKG[9] and EKG[10]
for (const i of [2, 5, 7, 9, 10]) {
    console.log(`EKG[${i}] = [${ekg(i, 10).join(', ')}]`);
}

console.log("Calculate and show here at which term EKG[5] and EKG[7] converge.");
const ekg5 = ekg(5, 100);
const ekg7 = ekg(7, 100);

for (let i = 1; i < ekg5.length; i++) {
    if (ekg5[i] === ekg7[i] && sameSeq(ekg5, ekg7, i)) {
        console.log(`EKG[5](${i + 1}) = EKG[7](${i + 1}) = ${ekg5[i]}, and are identical from this term on`);
        break;
    }
}

// Same last element, and all elements in sequence are identical
function sameSeq(seq1, seq2, n) {
    const list1 = seq1.slice(0, n).sort((a, b) => a - b);
    const list2 = seq2.slice(0, n).sort((a, b) => a - b);

    for (let i = 0; i < n; i++) {
        if (list1[i] !== list2[i]) {
            return false;
        }
    }
    return true;
}

// Without Map to identify seen terms, need to examine list.
//   Calculating 3000 terms in this manner takes 10 seconds
// With Map to identify the seen terms, calculating 3000 terms takes .1 sec.
function ekg(two, maxN) {
    const result = [];
    result.push(1);
    result.push(two);

    const seen = new Map();
    seen.set(1, 1);
    seen.set(two, 1);

    let minUnseen = two === 2 ? 3 : 2;
    let prev = two;

    for (let n = 3; n <= maxN; n++) {
        let test = minUnseen - 1;
        while (true) {
            test++;
            if (!seen.has(test) && gcd(test, prev) > 1) {
                result.push(test);
                seen.set(test, n);
                prev = test;

                if (minUnseen === test) {
                    do {
                        minUnseen++;
                    } while (seen.has(minUnseen));
                }
                break;
            }
        }
    }
    return result;
}

function gcd(a, b) {
    if (b === 0) {
        return a;
    }
    return gcd(b, a % b);
}
