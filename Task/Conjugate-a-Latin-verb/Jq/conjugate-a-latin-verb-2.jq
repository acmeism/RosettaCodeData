def rpad($len): tostring | ($len - length) as $l | . + (" " * $l)[:$l];

def endings: [
    [ "o", "as", "at", "amus", "atis",  "ant"],
    ["eo", "es", "et", "emus", "etis",  "ent"],
    [ "o", "is", "it", "imus", "itis",  "unt"],
    ["io", "is", "it", "imus", "itis", "iunt"]
];

def infinEndings: ["are", "ēre", "ere", "ire"];

def pronouns: ["I", "you (singular)", "he, she or it", "we", "you (plural)", "they"];

def englishEndings: [ "", "", "s", "", "", "" ];

def conjugate($infinitive; $english):
  def letters:  [explode[] | [.] | implode];
  ($infinitive|letters) as $letters
  | if $letters|length < 4 then "Infinitive is too short for a regular verb." | error
    else ($letters[-3:]|join("")) as $infinEnding
    |  (infinEndings | index($infinEnding)) as $conj
    | if $conj == null then "Infinitive ending -\($infinEnding) not recognized." | error
      else ($letters[:-3]|join("")) as $stem
      | "Present indicative tense, active voice, of '\(infinitive)' to '\($english)':",
        foreach endings[$conj][] as $ending (-1; .+1;
          "    \($stem + $ending|rpad(8)) \(pronouns[.]) \($english)\(englishEndings[.])" )
      end
   end;

def pairs: [["amare", "love"], ["vidēre", "see"], ["ducere", "lead"], ["audire", "hear"]];

pairs[]
| conjugate(.[0]; .[1])
