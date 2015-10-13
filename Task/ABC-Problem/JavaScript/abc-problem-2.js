let characters = "BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM";
let blocks = characters.split(" ").map(pair => pair.split(""));

function isWordPossible(word) {
  var letters = [...word.toUpperCase()];
  var length = letters.length;
  var copy = new Set(blocks);

  for (let letter of letters) {
    for (let block of copy) {
      let index = block.indexOf(letter);

      if (index !== -1) {
        length--;
        copy.delete(block);
        break;
      }
    }

  }
  return !length;
}

[
  "A",
  "BARK",
  "BOOK",
  "TREAT",
  "COMMON",
  "SQUAD",
  "CONFUSE"
].forEach(word => console.log(`${word}: ${isWordPossible(word)}`));
