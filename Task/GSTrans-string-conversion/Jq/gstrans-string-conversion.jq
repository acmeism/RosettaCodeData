def encode($upper):
  # helper function to encode bytes < 128
  def f:
    if (. >= 1 and . <= 26)
    then "|" + (if $upper then [. + 64]|implode else [. + 96]|implode end)
    elif . < 32
    then "|" + ([. + 64] | implode)
    elif . == 34   # quotation mark
    then "|\""
    elif . == 60   # less than
    then "|<"
    elif . == 124  # vertical bar
    then "||"
    elif . == 127  # DEL
    then "|?"
    else [.]|implode
    end ;
  . as $s
  | if ($s | (type != "string") or (length == 0)) then "Argument of encode must be a non-empty string." | error
    else # remove any outer quotation marks
    ($s | if (length > 1 and .[:1] == "\"" and .[-1:] == "\"") then .[1:-1] else . end) as $s
    # iterate through the string's codepoints
    | reduce ($s|explode)[] as $b ( {enc: ""};
             if $b < 128 then .enc += ($b|f)
             else .enc +=  "|!" + (($b - 128)|f)
             end)
    | .enc
    end;

def decode:
  # helper function for decoding bytes after "|"
  def f:
    if . == 34                  # quotation mark
    then 34
    elif . == 60                # less than
    then 60
    elif . == 63                # question mark
    then 127
    elif . >= 64 and . < 96     # @ + upper case letter + [\]^_
    then . - 64
    elif . == 96                # grave accent
    then 31
    elif . == 124               # vertical bar
    then 124
    elif . >= 97 and . < 127    # lower case letter + {}~
    then . - 96
    else .
    end;
  . as $s
  | if ($s | (type != "string") or (length == 0)) then "Argument of decode must be a non-empty string." | error
    else
    # remove any outer quotation marks
    ($s | if (length > 1 and .[:1] == "\"" and .[-1:] == "\"") then $s[1:-1] else . end) as $s
    | ($s|explode) as $bytes
    | ($bytes|length) as $bc
    | {i: 0, dec: "" }
    # iterate through the string's bytes decoding as we go
    | until(.i >= $bc;
        if $bytes[.i] != 124
        then .dec += ([$bytes[.i]] | implode)
        | .i += 1
        else
          if (.i < $bc - 1) and ($bytes[.i+1] != 33)
          then .dec += ([$bytes[.i+1] | f ] | implode)
          | .i += 2
          else
            if (.i < $bc - 2) and ($bytes[.i+2] != 124)
            then .dec += ([128 + $bytes[.i+2]] | implode)
            | .i += 3
            else
              if (.i < $bc - 3) and ($bytes[.i+2] == 124)
              then .dec += ([128 + ($bytes[.i+3] | f)] | implode)
              | .i += 4
              else .i += 1
              end
            end
          end
        end)
    | .dec
    end;

def strings: [
  "\fHello\u0007\n\r",
  "\r\n\u0000\u0005\u00f4\r\u00ff"
];

def uppers: [true, false];

def task1:
  range(0; strings|length) as $i
  | strings[$i]
  | uppers[] as $u
  | encode($u) as $enc
  | ($enc|decode) as $dec
  | "string: \(tojson)",
    "encoded (\(if $u then "upper" else "lower" end)) : \($enc|tojson)",
    "decoded : \($dec|tojson)",
    "string == decoded ? \($dec == .)\n"
;

def jstrings:[
    "ALERT|G",
    "wert↑",
    "@♂aN°$ª7Î",
    "ÙC▼æÔt6¤☻Ì",
    "\"@)Ð♠qhýÌÿ",
    "+☻#o9$u♠©A",
    "♣àlæi6Ú.é",
    "ÏÔ♀È♥@ë",
    "Rç÷\\%◄MZûhZ",
    "ç>¾AôVâ♫↓P"
];

def task2:
  "Julia strings: string -> encoded (upper) <- decoded (same or different)\n",
  ( jstrings[]
    | encode(true) as $enc
    | ($enc|decode) as $dec
    | "  \(tojson) -> \($enc|tojson) <- \($dec|tojson) (\( if . == $dec then "same" else "different" end))"
  );

task1, task2
