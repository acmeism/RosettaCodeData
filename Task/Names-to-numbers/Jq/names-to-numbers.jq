def check(cond; msg):
  if cond then . else msg | error end;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def trim: sub("^ +";"") | sub(" +$";"");

def when(cond; action):
  if cond then action else . end;

def names: {
    "one": 1,
    "two": 2,
    "three": 3,
    "four": 4,
    "five": 5,
    "six": 6,
    "seven": 7,
    "eight": 8,
    "nine": 9,
    "ten": 10,
    "eleven": 11,
    "twelve": 12,
    "thirteen": 13,
    "fourteen": 14,
    "fifteen": 15,
    "sixteen": 16,
    "seventeen": 17,
    "eighteen": 18,
    "nineteen": 19,
    "twenty": 20,
    "thirty": 30,
    "forty": 40,
    "fifty": 50,
    "sixty": 60,
    "seventy": 70,
    "eighty": 80,
    "ninety": 90,
    "hundred": 100,
    "thousand": 1e3,
    "million": 1e6,
    "billion": 1e9,
    "trillion": 1e12,
    "quadrillion": 1e15
};

def zeros: ["zero", "nought", "nil", "none", "nothing"];

def nameToNum:
  def seps: ",|-| and | ";
  . as $name
  | { text: ($name|trim|ascii_downcase) }
  | (.text|startswith("minus ")) as $isNegative
  | when($isNegative; .text |= (.[6:] | trim)
  | when(.text|startswith("a ")); .text = "one" + .text[1:])
  | [.text|splits(seps) | select(.!="")] as $words
  | ($words|length) as $size
  | if $size == 1 and any( zeros[]; . == $words[0]) then .sum = 0
    else . + {multiplier: 1,  lastNum: 0, sum: 0 }
    | reduce range($size-1;-1;-1) as $i (.;
        names[$words[$i]] as $num
        | check($num; "'\($words[$i])' is not a valid number")
        | check($num != .lastNum; "'\($name)' is not a well formed numeric string")
        | if ($num >= 1000)
          then check(.lastNum < 100; "'\($name)' is not a well formed numeric string")
               | .multiplier = $num
               | when($i == 0; .sum += .multiplier)
          elif $num >= 100
               then .multiplier *= 100
               | when($i == 0; .sum += .multiplier)
          elif $num >= 20
               then check(.lastNum < 10 or .lastNum < 90;
	                  "'\($name)' is not a well formed numeric string")
               | .sum += $num * .multiplier
          else check(.lastNum < 1 or .lastNum > 90;
	             "'\($name)' is not a well formed numeric string")
               | .sum += $num * .multiplier
          end
        | .lastNum = $num )
    end
  | if $isNegative then - .sum else .sum end
;

def tests: [
    "none",
    "one",
    "twenty-five",
    "minus one hundred and seventeen",
    "hundred and fifty-six",
    "minus two thousand two",
    "nine thousand, seven hundred, one",
    "minus six hundred and twenty six thousand, eight hundred and fourteen",
    "four million, seven hundred thousand, three hundred and eighty-six",
    "fifty-one billion, two hundred and fifty-two million, seventeen thousand, one hundred eighty-four",
    "two hundred and one billion, twenty-one million, two thousand and one",
    "minus three hundred trillion, nine million, four hundred and one thousand and thirty-one",
    "one quadrillion and one",
    "minus nine quadrillion, one hundred thirty-seven"
];

tests[]
| "\(nameToNum|lpad(17)) = \(.)"
