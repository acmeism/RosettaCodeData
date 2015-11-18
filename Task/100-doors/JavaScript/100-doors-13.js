// Array comprehension style
[ for (i of Array.apply(null, { length: 100 })) i ].forEach((_, i) => {
  var door = i + 1
  var sqrt = Math.sqrt(door);

  if (sqrt === (sqrt | 0)) {
    console.log("Door %d is open", door);
  }
});
