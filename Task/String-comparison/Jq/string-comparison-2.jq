# Only characters A to Z are affected
def downcase:
  explode | map( if 65 <= . and . <= 90 then . + 32  else . end) | implode;

# Only characters a to z are affected
def upcase:
  explode | map( if 97 <= . and . <= 122 then . - 32  else . end) | implode;
