def NNode($name; $children): {$name, $children};
def INode($level; $name):    {$level, $name};

# Input: {iNodes, n} where n is an NNode
# Output: the children of .n are updated
def toNest($start; $level):
  if $level == 0 then .n.name = .iNodes[0].name end
  | first( foreach (range( $start + 1; .iNodes|length), null) as $i (.;
        if $i == null then .emit = true
        elif .iNodes[$i].level == $level+1
        then (.n = NNode(.iNodes[$i].name; [])
              | toNest($i; $level+1)
              | .n) as $n
        | .n.children += [$n]
        | .emit = false
        elif (.iNodes[$i].level <= $level)
        then .emit = true
        end;
        if .emit then . else empty end) ) ;

def makeIndent($outline; $tab):
  (outline|split("\n")) as $lines
  | reduce range(0; $lines|length) as $i ([];
       $lines[$i] as $line
       | ($line|sub("^ *";"")) as $line2
       | ((($line|length) - ($line2|length)) / $tab | floor) as $level
       | . + [INode($level; $line2)] );

# Input: NNode
def toMarkup($cols; $depth):
  . as $n
  | "|-" as $l1
  | "|  |" as $l2

  # input: {span}
  | def colSpan($nn):
      reduce range(0; $nn.children|length) as $i (.;
         if ($i > 0) then .span += 1 end
         | colSpan($nn.children[$i] ))
  ; # end colSpan

  def nestedFor($nn; $level; $maxLevel; $col):
    if $level == 1 and $maxLevel > $level
    then reduce range(0; $nn.children|length) as $i (.;
           $nn.children[$i] as $c
           | nestedFor($c; 2; $maxLevel; $i) )
    elif $level < $maxLevel
    then reduce $nn.children[] as $c (.;
           nestedFor($c; $level+1; $maxLevel; $col) )
    elif $nn.children|length > 0
    then reduce range(0; $nn.children|length) as $i (.;
           $nn.children[$i] as $c
           | .span = 1
           | colSpan($c)
           | (if $maxLevel == 1 then $i + 1 else $col + 1 end) as $cn
           | .lines += ["| style=\"background: \($cols[$cn]) \" colspan=\(.span) | \($c.name)"] )
    else .lines += [$l2]
    end
  ; # end nestedFor

  reduce $n.children[] as $c (.span = 1; colSpan($c) )
  | .lines = ["{| class=\"wikitable\" style=\"text-align: center;\""]
  | .lines += [$l1]
  | .span = 1
  | colSpan($n)
  | "| style=\"background: \(cols[0]) \" colSpan=\(.span) | \($n.name)" as $s
  | .lines += [$s]
  | .lines += [$l1]

  | reduce range(1; $depth) as $maxLevel (.;
        nestedFor($n; 1; $maxLevel; 0)
        | if $maxLevel < $depth-1 then .lines += [$l1] end)
  | .lines += ["|}"]
  | .lines|join("\n") ;

def yellow: "#ffffe6;";
def orange: "#ffebd2;";
def green:  "#f0fff0;";
def blue:   "#e6ffff;";
def pink:   "#ffeeff;";

### Examples

def outline:
"Display an outline as a nested table.\n" +
"    Parse the outline to a tree,\n" +
"        measuring the indent of each line,\n" +
"        translating the indentation to a nested structure,\n" +
"        and padding the tree to even depth.\n" +
"    count the leaves descending from each node,\n" +
"        defining the width of a leaf as 1,\n" +
"        and the width of a parent node as a sum.\n" +
"            (The sum of the widths of its children) \n" +
"    and write out a table with 'colspan' values\n" +
"        either as a wiki table,\n" +
"        or as HTML.";


def cols: [yellow, orange, green, blue, pink];
def iNodes: makeIndent(outline; 4);
def n: NNode(""; []);

def outline2:
"Display an outline as a nested table.\n" +
"     Parse the outline to a tree,\n" +
"        measuring the indent of each line,\n" +
"        translating the indentation to a nested structure,\n" +
"        and padding the tree to even depth.\n" +
"    count the leaves descending from each node,\n" +
"        defining the width of a leaf as 1,\n" +
"        and the width of a parent node as a sum.\n" +
"            (The sum of the widths of its children) \n" +
"            Propagating the sums upward as necessary.\n" +
"    and write out a table with 'colspan' values\n" +
"        either as a wiki table,\n" +
"        or as HTML.\n" +
"    Optionally add color to the nodes.\n" ;

def cols2: [blue, yellow, orange, green, pink];

def iNodes2: makeIndent(outline2; 4);

def task1:
  { iNodes: iNodes, n: n}
  | toNest(0; 0)
  | .n
  | toMarkup(cols; 4) ;

def task2:
  { iNodes: iNodes2, n: n}
  | toNest(0; 0)
  | .n
  | toMarkup(cols2; 4) ;

task1, task2
