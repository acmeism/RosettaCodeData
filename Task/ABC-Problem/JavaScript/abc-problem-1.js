var blocks = "BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM";

function CheckWord(blocks, word) {
   // Makes sure that word only contains letters.
   if(word !== /([a-z]*)/i.exec(word)[1]) return false;
   // Loops through each character to see if a block exists.
   for(var i = 0; i < word.length; ++i)
   {
      // Gets the ith character.
      var letter = word.charAt(i);
      // Stores the length of the blocks to determine if a block was removed.
      var length = blocks.length;
      // The regexp gets constructed by eval to allow more browsers to use the function.
      var reg = eval("/([a-z]"+letter+"|"+letter+"[a-z])/i");
      // This does the same as above, but some browsers do not support...
      //var reg = new RegExp("([a-z]"+letter+"|"+letter+"[a-z])", "i");
      // Removes all occurrences of the match.
      blocks = blocks.replace(reg, "");
      // If the length did not change then a block did not exist.
      if(blocks.length === length) return false;
   }
   // If every character has passed then return true.
   return true;
};

var words = [
   "A",
   "BARK",
   "BOOK",
   "TREAT",
   "COMMON",
   "SQUAD",
   "CONFUSE"
];

for(var i = 0;i<words.length;++i)
   console.log(words[i] + ": " + CheckWord(blocks, words[i]));
