def magicSquareOdd:
  . as $n
  | if ($n < 3 or $n%2 == 0) then "Base must be odd and > 2" | error
    else ($n * $n) as $gridSize
    | { value: 1,
        c: (($n/2) | floor),
        r: 0,
        result: []}
    | until (.value > $gridSize;
        .result[.r][.c] = .value
        | if .r == 0
          then if (.c == $n - 1)
               then .r += 1
               else .r = ($n - 1) | .c += 1
               end
          elif (.c == $n - 1)
          then .r += -1
          | .c = 0
	      elif (.result[.r - 1][.c + 1] == null)
          then .r += -1 | .c += 1
          else .r += 1
	      end
        | .value += 1 )
    | .result
    end ;

def magicSquareSinglyEven:
  . as $n
  | if ($n < 6 or ($n - 2) % 4 != 0)
    then "Base must be a positive multiple of 4 plus 2" | error
    else ($n * $n) as $size
    | ($n / 2) as $halfN
    | ($size / 4) as $subSquareSize
    | ($halfN|magicSquareOdd) as $subSquare
    | [0, 2, 3, 1] as $quadrantFactors
    | reduce range(0; $n) as $r ({};
        reduce range(0; $n) as $c (.;
            ((($r/$halfN)|floor) * 2 + (($c/$halfN)|floor)) as $quadrant
            | .result[$r][$c] = $subSquare[$r % $halfN][$c % $halfN]
            | .result[$r][$c] += $quadrantFactors[$quadrant] * $subSquareSize ) )
    | (($halfN/2)|floor) as $nColsLeft
    | ($nColsLeft - 1) as $nColsRight
    | reduce range(0; $halfN) as $r (.;
        reduce range(0; $n) as $c (.;
           if ($c < $nColsLeft or $c >= $n - $nColsRight or ($c == $nColsLeft and $r == $nColsLeft))
	       then if ($c != 0 or $r != $nColsLeft)
                then .result[$r][$c] as $tmp
                | .result[$r][$c] = .result[$r + $halfN][$c]
                | .result[$r + $halfN][$c] = $tmp
                else .
		        end
           else .
	       end ) )
    | .result
    end ;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def task(n):
  "Magic constant: \((n * n + 1) * n / 2)\n",
  (n|magicSquareSinglyEven[] | map(lpad(3))|join(" ") );

task(6)
