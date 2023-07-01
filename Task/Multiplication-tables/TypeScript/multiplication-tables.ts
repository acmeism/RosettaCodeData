// Multiplication tables

var n = 12;
console.clear();
for (j = 1; j < n; j++)
  process.stdout.write(j.toString().padStart(3, ' ') + " ");
console.log(n.toString().padStart(3, ' '));
console.log("----".repeat(n) + "+");
for (i = 1; i <= n; i++) {
  for (j = 1; j <= n; j++)
    process.stdout.write(j < i ?
      "    " : (i * j).toString().padStart(3, ' ') + " ");
  console.log("| " + i.toString().padStart(2, ' '));
}
