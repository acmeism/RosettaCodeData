function display(numbers) {
  console.log(`[${numbers.join(", ")}]`);
}

function string_search_single(haystack, needle) {
  const index = haystack.indexOf(needle);
  return index;
}

function string_search(haystack, needle) {
  const result = [];
  let start = 0;
  let index = 0;

  while (index >= 0 && start < haystack.length) {
    const haystackReduced = haystack.substring(start);
    index = string_search_single(haystackReduced, needle);
    if (index >= 0) {
      result.push(start + index);
      start += index + needle.length;
    }
  }
  return result;
}

function main() {
  const texts = [
    "GCTAGCTCTACGAGTCTA",
    "GGCTATAATGCGTA",
    "there would have been a time for such a word",
    "needle need noodle needle",
    "DKnuthusesandprogramsanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguages",
    "Nearby farms grew an acre of alfalfa on the dairy's behalf, with bales of that alfalfa exchanged for milk.",
  ];

  const patterns = ["TCTA", "TAATAAA", "word", "needle", "and", "alfalfa"];

  for (let i = 0; i < texts.length; ++i) {
    console.log(`text${i + 1} = ${texts[i]}`);
  }
  console.log();

  for (let i = 0; i < texts.length; ++i) {
    const indexes = string_search(texts[i], patterns[i]);
    console.log(
      `Found "${patterns[i]}" in 'text${i + 1}' at indexes `
    );
    display(string_search(texts[i], patterns[i]));
  }
}

main();
