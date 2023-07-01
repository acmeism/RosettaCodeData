def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def d: [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
    [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
    [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
    [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
    [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
    [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
    [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
    [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
    [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
];

def inv: [0, 4, 3, 2, 1, 5, 6, 7, 8, 9];

def p: [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
    [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
    [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
    [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
    [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
    [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
    [7, 0, 4, 6, 9, 1, 3, 2, 5, 8]
];

# Output: an object: {emit, c}
def verhoeff($s; $validate; $table):

    {emit:
        (if $table then
          ["\(if $validate then "Validation" else "Check digit" end) calculations for '\($s)':\n",
           " i  nᵢ  p[i,nᵢ]  c",
           "------------------"]
        else []
        end),
       s: (if $validate then $s else $s + "0" end),
       c: 0 }
    | ((.s|length) - 1) as $le
    | reduce range($le; -1; -1) as $i (.;
        (.s[$i:$i+1]|explode[] - 48) as $ni
        | (p[($le-$i) % 8][$ni]) as $pi
        | .c = d[.c][$pi]
        | if $table
          then .emit += ["\($le-$i|lpad(2))  \($ni)      \($pi)     \(.c)"]
          else .
	  end )
    | if $table and ($validate|not)
      then .emit += ["\ninv[\(.c)] = \(inv[.c])"]
      else .
      end
    | .c = (if $validate then (.c == 0) else inv[.c] end);

def sts: [
  ["236", true],
  ["12345", true],
  ["123456789012", false]];

def task:
  sts[]
  | . as $st
  | verhoeff($st[0]; false; $st[1]) as {c: $c, emit: $emit}
  | $emit[],
    "\nThe check digit for '\($st[0])' is '\($c)'\n",
    ( ($st[0] + ($c|tostring)), ($st[0] + "9")
      | . as $stc
      | verhoeff($stc; true; $st[1]) as {emit: $emit, c: $v}
      | (if $v then "correct" else "incorrect" end) as $v
      | $emit[],
        "\nThe validation for '\($stc)' is \($v).\n" );

task
