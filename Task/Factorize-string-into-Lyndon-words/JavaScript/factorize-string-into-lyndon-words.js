function factorizeStringIntoLyndonWords() {
  // Create a 128 character Thue-Morse word
  let thueMorse = "0";
  for (let i = 0; i < 7; i++) {
    const thueMorseCopy = thueMorse;
    thueMorse = thueMorse.replace(/0/g, "a");
    thueMorse = thueMorse.replace(/1/g, "0");
    thueMorse = thueMorse.replace(/a/g, "1");
    thueMorse = thueMorseCopy + thueMorse;
  }

  console.log("The Thue-Morse word to be factorised:");
  console.log(thueMorse);

  console.log();
  console.log("The factors are:");
  const factors = duval(thueMorse);
  factors.forEach((factor) => {
    console.log(factor);
  });
}

// Duval's algorithm
function duval(text) {
  const factorisation = [];
  let i = 0;

  while (i < text.length) {
    let j = i + 1;
    let k = i;

    while (j < text.length && text.charAt(k) <= text.charAt(j)) {
      if (text.charAt(k) < text.charAt(j)) {
        k = i;
      } else {
        k += 1;
      }

      j += 1;
    }

    while (i <= k) {
      factorisation.push(text.substring(i, i + j - k));
      i += j - k;
    }
  }

  return factorisation;
}

factorizeStringIntoLyndonWords();
