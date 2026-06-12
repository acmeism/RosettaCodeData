function kmpSearch(pattern, text) {
  const result = [];
  const lps = constructLPS(pattern);

  let textIndex = 0;
  let patternIndex = 0;

  while (textIndex < text.length) {
    if (text[textIndex] === pattern[patternIndex]) {
      textIndex += 1;
      patternIndex += 1;
      if (patternIndex === pattern.length) {
        result.push(textIndex - patternIndex);
        patternIndex = lps[patternIndex - 1];
      }
    } else {
      if (patternIndex !== 0) {
        patternIndex = lps[patternIndex - 1];
      } else {
        textIndex += 1;
      }
    }
  }

  return result;
}

function constructLPS(pattern) {
  const lps = new Array(pattern.length).fill(0);
  let length = 0;
  let patternIndex = 1;

  while (patternIndex < pattern.length) {
    if (pattern[patternIndex] === pattern[length]) {
      length += 1;
      lps[patternIndex] = length;
      patternIndex += 1;
    } else {
      if (length !== 0) {
        length = lps[length - 1];
      } else {
        lps[patternIndex] = 0;
        patternIndex += 1;
      }
    }
  }

  return lps;
}

function main() {
  const texts = [
    "GCTAGCTCTACGAGTCTA",
    "GGCTATAATGCGTA",
    "there would have been a time for such a word",
    "needle need noodle needle",
    "InhisbookseriesTheArtofComputerProgrammingpublishedbyAddisonWesleyDKnuth" +
      "usesanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguages" +
      "toillustratetheconceptsandalgorithmsastheyarepresented",
    "Nearby farms grew a half acre of alfalfa on the dairy's behalf," +
      " with bales of all that alfalfa exchanged for milk.",
  ];

  const patterns = ["TCTA", "TAATAAA", "word", "needle", "put", "and", "alfalfa"];

  for (let i = 0; i < texts.length; i++) {
    console.log("Text" + (i + 1) + " = " + texts[i]);
  }
  console.log();

  for (let i = 0; i < patterns.length; i++) {
    const j = i < 5 ? i : i - 1;
    const result = kmpSearch(patterns[i], texts[j]);
    console.log(
      "Found '" + patterns[i] + "' in 'Text" + (j + 1) + "' at indices " + result
    );
  }
}

main();
