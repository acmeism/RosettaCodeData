Array.apply(null, { length: 100 })
  .map(function(v, i) { return i + 1; })
    .forEach(function(door) {
      var sqrt = Math.sqrt(door);

      if (sqrt === (sqrt | 0)) {
        console.log("Door %d is open", door);
      }
    });
