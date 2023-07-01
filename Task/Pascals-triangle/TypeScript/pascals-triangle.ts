// Pascal's triangle

function pascal(n: number): void {
  // Display the first n rows of Pascal's triangle
  // if n<=0 then nothing is displayed
  var ld: number[] = new Array(40); // Old
  var nw: number[] = new Array(40); // New
  for (var row = 0; row < n; row++) {
    nw[0] = 1;
    for (var i = 1; i <= row; i++)
      nw[i] = ld[i - 1] + ld[i];
    process.stdout.write(" ".repeat((n - row - 1) * 2));
    for (var i = 0; i <= row; i++) {
      if (nw[i] < 100)
        process.stdout.write(" ");
      process.stdout.write(nw[i].toString());
      if (nw[i] < 10)
        process.stdout.write(" ");
      process.stdout.write(" ");
    }
    nw[row + 1] = 0;
    // We do not copy data from nw to ld
    // but we work with references.
    var tmp = ld;
    ld = nw;
    nw = tmp;
    console.log();
  }
}

pascal(13);
