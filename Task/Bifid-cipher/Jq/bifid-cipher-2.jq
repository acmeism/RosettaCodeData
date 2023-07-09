# Input: the message to be encrypted
def encrypt($polybius):
  (ascii_upcase | gsub("J"; "I") ) as $m
  | {rows: [], cols : [] }
  | reduce ($m|chars) as $c (.;
      ($polybius|index($c)) as $ix
      | if $ix
        then .rows += [($ix/5)|floor + 1]
        | .cols += [($ix%5) + 1]
        else .
        end )
  | reduce (.rows + .cols | _nwise(2)) as $pair ("";
      (($pair[0] - 1) * 5 + $pair[1] - 1) as $ix
      | . + $polybius[$ix:$ix+1] ) ;

# Input: the message to be decrypted
def decrypt($polybius):
  reduce chars as $c ( {rows: [], cols : [] };
       ($polybius|index($c)) as $ix
       | .rows += [($ix/5)|floor + 1]
       | .cols += [($ix%5) + 1] )
  | ([.rows, .cols] | transpose | flatten) as $lines
  | ($lines|length/2) as $count
  | $lines[:$count] as $rows
  | $lines[$count:] as $cols
  | [$rows, $cols] as $d
  | reduce range(0; $count) as $i ("";
       (($rows[$i] - 1) * 5 + $cols[$i] - 1) as $ix
       | . + $polybius[$ix:$ix+1] ) ;

def polys:
  def p1: "ABCDEFGHIKLMNOPQRSTUVWXYZ";
  def p2: "BGWKZQPNDSIOAXEFCLUMTHYVR";
  def p3: "PLAYFIREXMBCDGHKNOQSTUVWZ";
  [p1, p2, p2, p3];

def messages: [
  "ATTACKATDAWN",
  "FLEEATONCE",
  "ATTACKATDAWN",
  "The invasion will start on the first of January"
  ];

def task:
  range(0; messages|length) as $i
  |  messages[$i]
  | encrypt(polys[$i]) as $encrypted
  | ($encrypted | decrypt(polys[$i] )) as $decrypted
  | "Message   : \(.)",
    "Encrypted : \($encrypted)",
    "Decrypted : \($decrypted)"
    "" ;

task
