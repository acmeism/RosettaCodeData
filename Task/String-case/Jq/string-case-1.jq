# like ruby's downcase - only characters A to Z are affected
def ascii_downcase:
  explode | map( if 65 <= . and . <= 90 then . + 32  else . end) | implode;

# like ruby's upcase - only characters a to z are affected
def ascii_upcase:
  explode | map( if 97 <= . and . <= 122 then . - 32  else . end) | implode;
