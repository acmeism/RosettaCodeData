def is_pangram:
  explode
  | map( if 65 <= . and . <= 90 then . + 32 # uppercase
         elif 97 <= . and . <= 122 then .   # lowercase
         else empty
         end )
  | unique
  | length == 26;

# Example:
"The quick brown fox jumps over the lazy dog" | is_pangram
