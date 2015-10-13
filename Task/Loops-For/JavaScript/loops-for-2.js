function range(i) {
  return i ? range(i - 1).concat(i) : [];
}

range(5) --> [1, 2, 3, 4, 5]
