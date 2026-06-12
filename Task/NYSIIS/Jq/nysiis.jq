### Generic utilities

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

# Output: a stream
def toChars: explode[] | [.] | implode;

### NYSIIS encoding

def fStrs: [["MAC", "MCC"], ["KN", "N"], ["K", "C"], ["PH", "FF"], ["PF", "FF"], ["SCH", "SSS"]];
def lStrs: [["EE", "Y"], ["IE", "Y"], ["DT", "D"], ["RT", "D"], ["RD", "D"], ["NT", "D"], ["ND", "D"]];
def mStrs: [["EV", "AF"], ["KN", "N"], ["SCH", "SSS"], ["PH", "FF"]];
def eStrs: ["JR", "JNR", "SR", "SNR"];

def isVowel: {"A": true, "E": true, "I": true, "O": true, "U": true}[.];

def isRoman:
  {"I": true, "V": true, "X": true} as $roman
  | all(explode[] | [.] | implode; $roman[.] );

def splitter: "[ |,]";

def nysiis:
  if . == "" then .
  else {w: ascii_upcase}
  | [.w | splits(splitter)] as $ww
  | if ($ww|length) > 1 and ($ww[-1]|isRoman) then .w = .w[0: (.w|length) - ($ww[-1]|length)] end
  | .w |= gsub("[ ,'-]"; "")
  | reduce eStrs[] as $eStr (.;
        if (.w|endswith($eStr)) then .w |= .[0: length - ($eStr|length)] end)
  | reduce fStrs[] as $fStr (.;
        if (.w|startswith($fStr[0])) then .w |= $fStr[1] + .[$fStr[0] | length :] end )
  | reduce lStrs[] as $lStr (.;
        if (.w|endswith($lStr[0])) then .w |= .[0:-2] + $lStr[1] end)
  | .key = .w[0:1]
  | .w |= .[1:]
  | reduce mStrs[] as $mStr (.; .w |= gsub($mStr[0]; $mStr[1]))
  | .sb = [.key[0:1], (.w|toChars)]
  | (.sb|length) as $len
  | reduce range(0; $len) as $i (.;
      .sb[$i] as $s
      | if   $s | test("[EIOU]") then .sb[$i] = "A"
        elif $s == "Q"           then .sb[$i] = "G"
        elif $s == "Z"           then .sb[$i] = "S"
        elif $s == "M"           then .sb[$i] = "N"
        elif $s == "K"           then .sb[$i] = "C"
        elif $s == "H"
        then
             if (.sb[$i-1] | isVowel | not) or ($i < $len-1 and ((.sb[$i+1] | isVowel) | not))
             then .sb[$i] = .sb[$i-1]
             end
        elif $s == "W"
        then if (.sb[$i-1]|isVowel) then .sb[$i] = "A" end
        end )
  | if .sb[-1] == "S" then .sb |= .[0: -1] end
  | if (.sb|length) > 1 and (.sb|join("")|.[-2:] == "AY")
    then .sb |= .[0:-2] + ["Y"]
    end
  | if .sb[-1] == "A" then .sb |= .[0:-1] end
  | .prev = .key[0:1]
  | reduce range(1; .sb|length) as $j (.;
      .sb[$j] as $c
      | if (.prev != $c)
        then .key += $c
        | .prev = $c
        end )
  | .key
  end ;

def names: [
    "Bishop", "Carlson", "Carr", "Chapman",
    "Franklin", "Greene", "Harper", "Jacobs", "Larson", "Lawrence",
    "Lawson", "Louis, XVI", "Lynch", "Mackenzie", "Matthews", "May jnr",
    "McCormack", "McDaniel", "McDonald", "Mclaughlin", "Morrison",
    "O'Banion", "O'Brien", "Richards", "Silva", "Watkins", "Xi",
    "Wheeler", "Willis", "brown, sr", "browne, III", "browne, IV",
    "knight", "mitchell", "o'daniel", "bevan", "evans", "D'Souza",
    "Hoyle-Johnson", "Vaughan Williams", "de Sousa", "de la Mare II"
];

names[]
| . as $name
| nysiis
| . as $ny
| (if length > 6 then "\($ny[0:6])(\($ny[6:]))"
   else $ny
   end) as $name2
| "\($name|lpad(16)) : \($name2)"
