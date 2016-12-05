var a = [];
for (var i = 1; i < 23; i++) a[i] = i + Math.floor(1/2 + Math.sqrt(i));
console.log(a);

for (i = 1; i < 1000000; i++) if (Number.isInteger(i + Math.floor(1/2 + Math.sqrt(i))) === false) {
    console.log("The ",i,"th element of the sequence is a square");
}
