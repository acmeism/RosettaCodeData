function square(n) {
  for (let i = 1; i <= n; i++) {
    const filler = i == 1 || i == n ? "1 " : "0 ";
    console.log("1 " + Array(n - 1).join(filler) + "1");
  }
}

square(6);
