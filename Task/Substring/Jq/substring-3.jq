# starting from n characters in and of m length:  .[n+1: n+m+1]
"s[1:2] => \( s[1:2] )",

# starting from n characters in, up to the end of the string:  .[n+1:]
"s[9:] => \( s[9:] )",

# whole string minus last character: .[0:length-1]
"s|.[0:length-1] => \(s | .[0:length-1] )",

# starting from a known character within the string and of m length:
  # jq 1.4: ix(c) as $i | .[ $i: $i + m]
  # jq>1.4: match(c).offset as $i | .[ $i: $i + m]
"s | ix(\"五\") as $i | .[$i: $i + 1] => \(s | ix("五") as $i | .[$i: $i + 1] )",


# starting from a known substring within the string and of m length:
  # jq 1.4: ix(sub) as $i | .[ $i: $i + m]
  # jq>1.4: match(sub).offset as $i | .[ $i: $i + m]
"s | ix(\"五六\") as $i | .[$i: $i + 2] => " +
 "\( s | ix("五六") as $i | .[$i: $i + 2] )"
