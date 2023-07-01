// N'th
function suffix(n: number): string {
  var nMod10: number = n % 10;
  var nMod100: number = n % 100;
  if (nMod10 == 1 && nMod100 != 11)
    return "st";
  else if (nMod10 == 2 && nMod100 != 12)
    return "nd";
  else if (nMod10 == 3 && nMod100 != 13)
    return "rd";
  else
    return "th";
}

function printImages(loLim: number, hiLim: number) {
  for (i = loLim; i <= hiLim; i++)
    process.stdout.write(`${i}` + suffix(i) + " ");
  process.stdout.write("\n");
}

printImages(   0,   25);
printImages( 250,  265);
printImages(1000, 1025);
