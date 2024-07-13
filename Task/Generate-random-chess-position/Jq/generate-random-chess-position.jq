### Pseuo-random numbers

# Output: a prn in range(0;$n) where $n is `.`
def prn:
  if . == 1 then 0
  else . as $n
  | ([1, (($n-1)|tostring|length)]|max) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

def sample:
  if length == 0 # e.g. null or []
  then null
  else .[length|prn]
  end;

def randFloat:
  (1000|prn) / 1000;

### Chess

def isEmpty: . == "." or . == "•";

def grid:
  [range(0;4) |  (".","•") ] as $black
  | [range(0;4) | ("•", ".")] as $white
  | [range(0;4) | ($black, $white)] ;

# input: {grid}
def placeKings:
  .done = false
  | until(.done;
      [8 | prn, prn, prn, prn] as [$r1, $c1, $r2, $c2]
      | if $r1 != $r2 and (($r1 - $r2)|length) > 1 and (($c1 - $c2)|length) > 1
        then   .grid[$r1][$c1] = "K"
             | .grid[$r2][$c2] = "k"
             | .done = true
        else .
        end )
  | del(.done);

# input: {grid}
def placePieces($pieces; $isPawn):
  ($pieces|length|prn) as $numToPlace
  | .n = -1
  | until(.n == $numToPlace;
      .n += 1
      | .done = false
      | until(.done;
            .r = (8 | prn)
          | .c = (8 | prn)
          | if (.grid[.r][.c] | isEmpty) and (($isPawn and (.r == 7 or .r == 0))|not)
            then .done = true
            else .
            end )
      | .grid[.r][.c] = $pieces[.n:.n+1] ) ;

def toFen:
    { grid,
      fen: "",
      countEmpty: 0 }
    | reduce range (0;8) as $r (.;
        reduce range(0;8) as $c (.;
            .grid[$r][$c] as $ch
            | .emit += " \($ch) "
            | if ($ch | isEmpty)
              then .countEmpty += 1
              else
                if .countEmpty > 0
                then .fen +=  (.countEmpty|tostring)
                | .countEmpty = 0
                end
              | .fen += $ch
              end )
        | if .countEmpty > 0
          then .fen += (.countEmpty|tostring)
          | .countEmpty = 0
          end
        | .fen += "/"
        | .emit += "\n" )
  | .emit,
    .fen + " w - - 0 1" ;

def createFen:
  {grid: grid}
  | placeKings
  | placePieces("PPPPPPPP"; true)
  | placePieces("pppppppp"; true)
  | placePieces("RNBQBNR"; false)
  | placePieces("rnbqbnr"; false)
  | toFen;

createFen
