const randint = n => Math.floor(Math.random() * n);
const bases = ["A", "C", "G", "T"];
const baseseq = n => Array(n).fill(4).map(x => bases[randint(x)]).join("");
const dna = baseseq(200);
const subseq = new RegExp(baseseq(4), "g");

let matches = [];
while (subseq.exec(dna) !== null) {
  matches.push(subseq.lastIndex - 4);
}

console.log("Random DNA sequence:");
for (let i = 0; i < 4; i++) {
  console.log(dna.slice(i * 50, (i + 1) * 50));
}

console.log(`Subsequence to find: ${subseq.source}`);
console.log(matches.length > 0 ? `Match(es) found at position(s): ${matches.join(" ")}` : "No match found.");
