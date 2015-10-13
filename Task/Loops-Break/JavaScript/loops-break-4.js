console.log(
  (function streamTillInitialTen() {
    var nFirst = Math.floor(Math.random() * 20);

    if (nFirst === 10) return [10];

    return [
      nFirst,
      Math.floor(Math.random() * 20)
    ].concat(
      streamTillInitialTen()
    );
  })().join('\n')
);
