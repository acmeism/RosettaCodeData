Array.apply(null, { length: 100 })
  .map((v, i) => i + 1)
    .forEach(door => {
      var sqrt = Math.sqrt(door);

      if (sqrt === (sqrt | 0)) {
        console.log("Door %d is open", door);
      }
    });
