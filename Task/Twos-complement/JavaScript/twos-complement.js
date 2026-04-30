console.log([0, 1, -1, 42, 10 ** 11].map(x => ~x + 1).join(" "));
console.log(~BigInt(10 ** 11) + 1n);
