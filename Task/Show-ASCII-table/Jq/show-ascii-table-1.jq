# Pretty printing
def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

def table($ncols; $colwidth):
  nwise($ncols) | map(lpad($colwidth)) | join(" ");

# transposed table
def ttable($rows):
  [nwise($rows)] | transpose[] | join(" ");

# Representation of control characters, etc
def humanize:
  def special:
  { "0": "NUL",    "7": "BEL",    "8": "BKS",
    "9": "TAB",   "10": "LF ",   "13": "CR ",
   "27": "ESC",  "127": "DEL",  "155": "CSI" };

  if . < 32 or . == 127 or . == 155
  then (special[tostring] // "^" + ([64+.]|implode))
  elif . > 127 and . < 160 then "\\\(.+72|tostring)"
  else [.] | implode
  end
  | lpad(4) ;
