# Input: filename
# Output: if the filename ends with one of the extensions (ignoring case), output that extension; else output null.
# Assume that the list of file extensions consists of lower-case strings, including a leading period.
def has_extension(list):
  def ascii_downcase: explode | map( if 65 <= . and . <= 90 then . + 32  else . end) | implode;
  rindex(".") as $ix
  | if $ix then (.[$ix:] | ascii_downcase) as $ext
       | if list | index($ext) then $ext else null end
    else null
    end;
