function conjugate(verb) {
  if(verb.length < 4) {
    return `Can't conjugate ${verb} (not enough letters)`;
  }
  const suffixes = ["are", "ere", "ēre", "ire"];
  const declensions = [["o", "as", "at", "amus", "atis", "ant"],
                       ["o", "is", "it", "imus", "itis", "unt"],
                       ["eo", "es", "et", "emus", "etis", "ent"],
                       ["io", "is", "it", "imus", "itis", "iunt"]];

  for (let i = 0; i < 4; i++) {
    if (verb.endsWith(suffixes[i])){
      var conjugated = declensions[i].map(s => verb.replace(/.re$/, "") + s);
      break;
    }
  }
  try {
    const result = conjugated.join(" ");
    console.log(`Conjugation of ${verb}:`);
    return result;
  } catch {
    return `Can't conjugate ${verb} (not a regular ending)`;
  }
}

const test_verbs = ["amare", "venire", "monēre", "tegere", "are", "qwerty"];
for (const verb of test_verbs) {
  console.log(conjugate(verb));
}
