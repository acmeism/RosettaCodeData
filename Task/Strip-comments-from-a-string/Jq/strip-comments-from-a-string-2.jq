# define whitespace here as a tab, space, newline, return or form-feed character:
def is_whitespace: . as $in | " \n\r\f\t" | index($in);

def ltrim:
  if .[0:1] | is_whitespace then (.[1:]|ltrim) else . end;

def rtrim:
  if .[length-1:] | is_whitespace then .[0:length-1]|rtrim else . end;

def trim: ltrim | rtrim;

def strip_comment:
  index("#") as $i1 | index(";") as $i2
  | (if $i1 then if $i2 then [$i1, $i2] | min
                 else $i1
                 end
     else $i2
     end ) as $ix
  | if $ix then .[0:$ix] else . end
  | trim;
