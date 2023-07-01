// Balanced brackets

function isStringBalanced(str: string): bool {
  var paired = 0;
  for (var i = 0; i < str.length && paired >= 0; i++) {
    var c = str.charAt(i);
    if (c == '[')
      paired++;
    else if (c == ']')
      paired--;
  }
  return (paired == 0);
}

function generate(n: number): string {
  var opensCount = 0, closesCount = 0;
  // Choose at random until n of one type generated
  var generated: string[] = new Array(); // Works like StringBuilder
  while (opensCount < n && closesCount < n) {
    if (Math.floor(Math.random() * 2) == 0) {
      ++opensCount;
      generated.push("[");
    } else {
      ++closesCount;
      generated.push("]");
    }
  }
  // Now pad with the remaining other brackets
  generated.push(opensCount == n ?
    "]".repeat(n - closesCount) :
    "[".repeat(n - opensCount));
  return generated.join("");
}

console.log("Supplied examples");
var tests: string[] = ["", "[]", "][", "[][]", "][][", "[[][]]", "[]][[]"];
for (var test of tests)
  console.log(`The string '${test}' is ${(isStringBalanced(test) ? "OK." : "not OK."));
console.log();
console.log("Random generated examples");
for (var example = 0; example < 10; example++) {
  var test = generate(Math.floor(Math.random() * 10) + 1);
  console.log(`The string '${test}' is ${(isStringBalanced(test) ? "OK." : "not OK.")}`);
}
