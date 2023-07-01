### Utilities
# The glyphs in .
def chars: explode[] | [.] | implode;

# input: an array
# $keys : an array of strings
def objectify($keys):
  with_entries(.key = $keys[.key]) ;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;


def Symbols: ["k", "q", "r", "b", "n"];

def A: ["K", "Q", "R", "B", "N"]     | objectify(Symbols);
def W: ["♔", "♕", "♖", "♗", "♘"]  | objectify(Symbols);
def B: ["♚", "♛", "♜", "♝", "♞"]  | objectify(Symbols);

def krn: [
    "nnrkr", "nrnkr", "nrknr", "nrkrn",
    "rnnkr", "rnknr", "rnkrn",
    "rknnr", "rknrn",
    "rkrnn"
];

# $sym specifies the Symbols
# $id specifies the position
def chess960($sym):
  . as $id
  | { q:   (($id/4)|floor),
      r:   ($id % 4)
    }
  | .pos[.r*2+1] = $sym.b
  | .t = .q
  | .q |= ((./4)|floor)
  | .r = (.t % 4)
  | .pos[.r*2] = $sym.b
  | .t = .q
  | .q |= ((./6)|floor)
  | .r = .t % 6
  | .i = 0
  | .break = false
  | until( .break;
      if .pos[.i] == null
      then if .r == 0
           then .pos[.i] = $sym.q
           | .break = true
           else .r += -1
           end
      else .
      end
      | .i += 1 )
  | .i = 0
  | reduce (krn[.q]|chars) as $f (.;
      # find next insertion point
      until(.pos[.i] == null; .i += 1)
      | if  $f | IN("k", "r", "n")
        then .pos[.i] = $sym[$f]
        else .
        end )
  | .pos
  | join(" ") ;

def display960($sym):
 "\(lpad(3))  \(chess960($sym))";

" ID  Start position",
( 0, 518, 959 |  display960(A) ),
"\nPseudo-random starting positions:",
(699, 889, 757, 645, 754 | display960(W))
