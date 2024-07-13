# Left justify .
def ljust($width; $pad):
  tostring as $s
  | ($s|length) as $length
  | if $width > $length
    then $s + $pad * ($width - $length)
    else $s
    end;

def sortedOutline($ascending):

  def del: "\u007f";
  def sep: "\u0000";

  if .[0] | test("^[ \t]")
  then "    outline structure is unclear" | error
  else
    reduce range(1; length) as $i (
      { outline: .,
        indent: "",
        messages: [] };
      .outline[$i] as $line
      | ($line|length) as $lc
      | if $line | test("^(  | \t|\t)")
        then ($line | sub("^[ \t]*";"") | length) as $lc2
        | $line[0:$lc-$lc2] as $currIndent

        | if .indent == ""
          then .indent = $currIndent
          else .correctionNeeded = false
          | if (($currIndent|test("\t")) and (.indent|contains("\t") | not)) or
               (($currIndent|test("\t")|not) and (.indent|test("\t")))
            then .messages += [.indent + "corrected inconsistent whitespace use at line '\($line)'"]
            | .correctionNeeded = true
            elif (($currIndent|length) % (.indent|length)) != 0
            then .messages += [.indent + "corrected inconsistent indent width at line '\($line)'"]
            | .correctionNeeded = true
            end
          | if .correctionNeeded
            then ((($currIndent|length) / (.indent|length)) |round) as $mult
            | .outline[$i] = (.indent * $mult) + $line[$lc-$lc2:]
            end
          end
        end )
  end
  | .levels = [range(0; .outline|length) | 0]
  | .levels[0] = 1
  | .level = 1
  | .margin = ""
  # while any of the levels is 0 ...
  | until( all( .levels[]; . > 0);
      (.margin|length) as $mc
      | reduce range(1; .outline|length) as $i (.;
          if .levels[$i] == 0
          then .outline[$i] as $line
          | .margin as $margin
          | if ($line|startswith($margin)) and
               ($line[$mc:$mc+1] | (. != " ") and (. != "\t"))
            then .levels[$i] = .level
            end
          end )
      | .margin += .indent
      | .level += 1 )
  | .lines = [range(0; .outline|length) | ""]
  | .lines[0] = .outline[0]
  | .nodes = []
  | reduce range(1; .outline|length) as $i (.;
      if .levels[$i] > .levels[$i-1]
      then .nodes += [ if .nodes|length == 0 then .outline[$i-1] else sep + .outline[$i-1] end]
      elif .levels[$i] < .levels[$i-1]
      then (.levels[$i-1] - .levels[$i] ) as $j
      # remove $j elements from the tail
      | .nodes |= .[0: length-$j]
      end
      | if .nodes|length > 0
        then .lines[$i] = (.nodes|join("")) + sep + .outline[$i]
        else .lines[$i] = .outline[$i]
        end )
  | if $ascending
    then .lines |= sort
    else (.lines | map(length) | max) as $maxLen
    | reduce range(0; .lines|length) as $i (.;
        .lines[$i] |= ljust($maxLen; del) )
    | .lines |= (sort|reverse)
    end
  | reduce range(0; .lines|length) as $i (.;
      (.lines[$i]|split(sep) ) as $s
      | .lines[$i] = $s[-1]
      | if ($ascending|not)
        then .lines[$i] |= sub( del + "+$"; "")
        end )
  # First print the messages, and then the lines:
  | (select((.messages|length) > 0)
     | (.messages | join("\n")) + "\n"),

    (.lines|join("\n")) ;


### Examples

def outline: [
    "zeta",
    "    beta",
    "    gamma",
    "        lambda",
    "        kappa",
    "        mu",
    "    delta",
    "alpha",
    "    theta",
    "    iota",
    "    epsilon"
];

def outline2:
  outline | map(gsub("    "; "\t"));

def outline3: [
    "alpha",
    "    epsilon",
	"        iota",
    "    theta",
    "zeta",
    "    beta",
    "    delta",
    "    gamma",
    "    \t   kappa", # same length but \t instead of space
    "        lambda",
    "        mu"
];

def outline4: [
    "zeta",
    "    beta",
    "   gamma",
    "        lambda",
    "         kappa",
    "        mu",
    "    delta",
    "alpha",
    "    theta",
    "    iota",
    "    epsilon"
];


(outline
| "Four space indented outline, ascending sort:",
   sortedOutline(true),
  "\nFour space indented outline, descending sort:",
  sortedOutline(false)),

(outline2
| "\nTab indented outline, ascending sort:",
  sortedOutline(true),
  "\nTab indented outline, descending sort:",
  sortedOutline(false) ),

(outline3
| "\nFirst unspecified outline, ascending sort:",
  sortedOutline(true),
 "\nFirst unspecified outline, descending sort:",
  sortedOutline(false) ),

(outline4
| "\nSecond unspecified outline, ascending sort:",
  sortedOutline(true),
  "\nSecond unspecified outline, descending sort:",
  sortedOutline(false))
