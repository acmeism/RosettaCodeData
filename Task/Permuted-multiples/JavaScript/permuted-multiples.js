const digsort = n => [...String(n)].toSorted().join();

function samedigits(n) {
  for (let i = 2; i <= 6; i++) {
    if (digsort(n) !== digsort(n * i)) {
      return false;
    }
  }
  return true;
}

main: {
  let d = 1;
  while (d++) {
    const start = 10 ** d;
    for (let n = start; n < start * 10 / 6; n++) {
      if (samedigits(n)) {
        console.log(`Found n = ${n}:`);
        for (let i = 2; i <= 6; i++) {
          console.log(`n * ${i} = ${n * i}`);
        }
        break main;
      }
    }
    console.log(`Nothing found below ${start * 10}`);
  }
}
