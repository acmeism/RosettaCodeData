function pig_latin_word(word) {
  let new_word = '';
  let letters = word.split('');

  let non_vowel_letters = [];

  let first_vowel_idx = 0;

  let i = -1;

  for (let letter of letters) {
    i++;

    if (!['a', 'e', 'i', 'o', 'u'].includes(letter)) {non_vowel_letters.push(letter); continue;}

    first_vowel_idx = i;
    break;
  }

  return word.substr(first_vowel_idx, 9999) + non_vowel_letters.join("") + 'ay';
}

function pig_latin_sentence(sentence) {
  return sentence.split(" ").map(pig_latin_word).join(" ");
}
