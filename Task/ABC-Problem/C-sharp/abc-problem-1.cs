using System;
using System.IO;
// Needed for the method.
using System.Text.RegularExpressions;
using System.Collections.Generic;

void Main()
{
   string blocks = "BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM";
   List<string> words = new List<string>() {
      "A", "BARK", "BOOK", "TREAT", "COMMON", "SQUAD", "CONFUSE"
   };

   foreach(var word in words)
   {
      Console.WriteLine("{0}: {1}", word, CheckWord(blocks, word));
   }
}

bool CheckWord(string blocks, string word)
{
   for(int i = 0; i < word.Length; ++i)
   {
      int length = blocks.Length;
      Regex rgx = new Regex("([a-z]"+word[i]+"|"+word[i]+"[a-z])", RegexOptions.IgnoreCase);
      blocks = rgx.Replace(blocks, "", 1);
      if(blocks.Length == length) return false;
   }
   return true;
}
