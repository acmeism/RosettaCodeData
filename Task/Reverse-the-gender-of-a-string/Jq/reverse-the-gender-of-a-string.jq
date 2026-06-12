def swaps: {
  "She": "He", "she": "he", "Her": "His", "her": "his", "hers": "his", "He": "She",
  "he": "she", "His": "Her", "his": "her", "him": "her"
};

def isPunctuation:
   type == "string" and
   length == 1 and
   # test("[!\"#%&'()*,-./:;?@\\[\\]\\\\_{}¡§«¶·»¿]")
   # open, close, other
   test("\\p{Ps}|\\p{Pe}|\\p{Po}|")
;

def reverseGender:
  reduce splits("  *") as $word ([];
    swaps[$word] as $s
    | if $s then . + [$s]
      elif ($word[-1:] | isPunctuation)
      then swaps[$word[:-1]] as $s
      | if $s then . + [$s + $word[-1:]]
        else . + [$word]
        end
      else . + [$word]
     end)
  | join(" ");

def sentences: [
  "She was a soul stripper. She took his heart!",
  "He was a soul stripper. He took her heart!",
  "She wants what's hers, he wants her and she wants him!",
  "Her dog belongs to him but his dog is hers!"
];

sentences[]
| reverseGender
