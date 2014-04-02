for (var door = 1; door <= 100; i++) {
  var sqrt = Math.sqrt(door);
  if (sqrt === (sqrt | 0)) {
    console.log("Door %d is open", door);
  }
}
