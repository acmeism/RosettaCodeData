# node of a nested representation
def NNode($name; $children): {$name, $children};

# node of an indented representation:
def INode($level; $name): {$level, $name};

# Output: string representation of an NNode structure
def printNest:
  . as $nested
  # input: string so far
  | def printNest($n; $level):
      if ($level == 0) then "\n==Nest form==\n\n" else . end
      | reduce ($n.children[], null) as $c ( . + "\(("  " * $level) // "")\($n.name)\n";
        if $c == null then .
        else . + ("  " * ($level + 1)) | printNest($c; $level + 1)
      end );
  printNest($nested; 0);

# input: an INode structure
# output: the corresponding NNode structure
def toNest:
  . as $in
  | def toNest($iNodes; start; level):
      { i: (start + 1),
        n: (if (level == 0) then .name = $iNodes[0].name else . end)
      }
      | until ( (.i >= ($iNodes|length)) or .done;
          if ($iNodes[.i].level == level + 1)
          then .i as $i
	  | (NNode($iNodes[$i].name; []) | toNest($iNodes; $i; level+1)) as $c
          | .n.children += [$c]
          else if ($iNodes[.i].level <= level) then .done = true else . end
          end
          | .i += 1 )
      | .n ;
  NNode(""; []) | toNest($in; 0; 0);

# Output: string representation of an INode structure
def printIndent:
  "\n==Indent form==\n\n"
  + reduce .[] as $n ("";
      . + "\($n.level) \($n.name)\n") ;

# output: representation using INode
def toIndent:
  def toIndent($n; level):
    . + [INode(level; $n.name)]
      + reduce $n.children[] as $c ([];
           toIndent($c; level+1) );
  . as $in	
  | [] | toIndent($in; 0);


### Example

def n:  NNode(""; []);
def n1: NNode("RosettaCode"; []);
def n2: NNode("rocks"; [NNode("code"; []), NNode("comparison"; []), NNode("wiki"; [])] );
def n3: NNode("mocks"; [NNode("trolling"; [])]);

def n123:
  n1
  | .children += [n2]
  | .children += [n3];

### The task
def nested:
  n123
  | printNest ;

def indented:
  n123
  | toIndent
  | printIndent;

def roundtrip:
  n123
  | toIndent
  | toNest
  | printNest;

def task:
  nested as $nested
  | roundtrip as $roundtrip
  | $nested, indented, $roundtrip,
    "\nRound trip test satisfied? \($nested == $roundtrip)" ;

task
