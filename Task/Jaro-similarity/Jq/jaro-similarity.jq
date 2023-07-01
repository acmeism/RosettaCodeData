def jaro($s1; $s2):
    ($s1|length) as $le1
    | ($s2|length) as $le2
    | if $le1 == 0 and $le2 == 0 then 1
      elif $le1 == 0  or $le2 == 0 then 0
      else ((((if $le2 > $le1 then $le2 else $le1 end) / 2) | floor) - 1) as $dist
      | {matches: 0, matches2: [], matches2: [], transpos: 0 }
      | reduce range(0; $le1) as $i (.;
            (($i - $dist)     | if . < 0    then 0    else . end) as $start
          | (($i + $dist + 1) | if . > $le2 then $le2 else . end) as $stop
          | .k = $start
	  | until(.k >= $stop;
              if (.matches2[.k] or $s1[$i:$i+1] != $s2[.k:.k+1])|not
              then .matches1[$i] = true
              | .matches2[.k] = true
              | .matches += 1
	      | .k = $stop
	      else .k += 1
	      end) )
      | if .matches == 0 then 0
        else .k = 0
        | reduce range(0; $le1) as $i (.;
            if .matches1[$i]
	    then until(.k >= $le2 or .matches2[.k]; .k += 1)
	    | if .k < $le2 and ($s1[$i:$i+1] != $s2[.k:.k+1]) then .transpos += 1 else . end
      	    | .k += 1
	    else .
	    end )
        | .transpos /= 2
        | (.matches/$le1 + .matches/$le2 + ((.matches - .transpos)/.matches)) / 3
        end
      end ;

def task:
  [["MARTHA","MARHTA"],
   ["DIXON", "DICKSONX"],
   ["JELLYFISH","SMELLYFISH"],
   ["ABC","DEF"]][]
  | (jaro(.[0]; .[1]) * 1000 | floor / 1000) as $d
  | "jaro(\(.[0]); \(.[1])) => \($d)";

task
