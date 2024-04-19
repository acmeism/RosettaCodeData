def allDigits:
   all(explode[]; 48 <= . and . <= 57);

def lpad($len): tostring | ($len - length) as $l | ("0" * $l) + .;

def deBruijn:
  {deBruijn: ""}
  | reduce range(0; 100) as $n (.;
    ($n|lpad(2)) as $a
    | ($a | explode) as [$a1, $a2]
    | if $a2 >= $a1
      then .deBruijn += (if ($a1 == $a2)  then ([$a1]|implode) else $a end)
      | .m = $n + 1
      | until(.m > 99;
             (.m|lpad(2)) as $ms
             | if ($ms[1:2]|explode[0]) > $a1
               then .deBruijn +=  $a + $ms
               end
             | .m += 1 )
      end )
  | .deBruijn + "000" ;

def describe:
  . as $d
  | "de Bruijn sequence length: \($d|length)",
  "First 130 characters:",
   $d[0:130],
  "Last 130 characters:",
   $d[-130:];

def check:
  . as $text
  | { res: [],
      found: [range(0;10000) | 0],
      k: 0 }
  | reduce range( 0; $text|length-3) as $i (.;
      $text[$i : $i+4] as $s
      | if ($s|allDigits)
        then .k = ($s|tonumber)
        | .found[.k] += 1
        end )
  | reduce range(0; 10000) as $i (.;
        .k = .found[$i]
        | if .k != 1
          then ("  Pin number \($i) "
                + (if .k == 0 then "missing" else "occurs \(.k) times" end ) ) as $e
          | .res += [$e]
          end )
  | .k = (.res|length)
  | if .k == 0
    then .res = "No errors found"
    else
        (if .k == 1 then "" else "s" end) as $s
        | .res = "\(.k) error\($s) found:\n" + (.res | join("\n"))
    end
  | .res ;

# The tasks
deBruijn
| describe,
  "Missing 4 digit PINs in this sequence: \(check)",
  "Missing 4 digit PINs in the reversed sequence: \(explode|reverse|implode|check)",

  "4,444th digit in the sequence: '\(.[4443])' (setting it to '.')",
  ( .[0:4443] + "." + .[4444:]
    | "Re-running checks: \(check)" )
