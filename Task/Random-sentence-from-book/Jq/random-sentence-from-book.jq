include "MRG32k3a" {search: "."}; # see above

### Generic functions

def sum(stream): reduce stream as $s (0; . +$s);

### Random sentences
# puctuation to keep (also keep hyphen and apostrophe but do not count as words)
def ending:  ".!?";
def pausing:" ,:;";

# regex for removing puctuation
def removing: "[\"#\\$\\%&\\(\\)\\*\\+/<=>@\\[\\\\]^_`{|}~“”]";

# Emit a stream of lines
def text:
  foreach inputs as $in (null;
   if . then $in
   else # skip to start
      ($in|index("No one would have believed")) as $ix
      | if $ix then $in[$ix:] end
   end;
   select(.)
   | gsub( removing; "" )      # remove extraneous punctuation
   | gsub("[\r—]"; " ")        # replace \r and EM DASH (unicode 8212) with a space
);

def pairsAndTriples(stream):
  reduce stream as $x ({};
    .pair as $in2
    | .triple as $in3
    | if .pair | length <= 1 then .pair += [$x] end
    | if .triple | length <= 2 then .triple += [$x] end
    | if .pair | length == 2
      then # .dict2[ .pair | join(" ")] += 1
       .dict[ .pair[0] ][.pair[1]] += 1
      end
    | if $in2 | length == 2
      then .pair |= [ last, $x]
      end

    | if .triple | length == 3
      then .dict3[.triple[0:2]|join(" ")][ .triple[2]] += 1
      end
    | if $in3 | length == 3
      then .triple |= .[1:] + [$x]
      end
     ) ;

# split into words
def words:
  text
  | splits(" +")
  | select(length>0)
  | (first( foreach (ending, pausing | split("")[]) as $x (.;
              if endswith($x) then [.[:-1], .[-1:]] end)
            | select(type=="array")) | .[])
    // .
;

# $randomFloat should be a randomFloat value
# . should be a JSON object with {WORD: count} pairs
def weightedRandomChoice($randomFloat):
  to_entries
  | . as $entries
  | .[0].key as $default
  | sum( .[] | .value) as $n
  | ($n * $randomFloat | floor) as $r
  | first(
      { sum: 0 }
      | foreach $entries[] as $kv (.;
          .key = $kv.key
          | .sum += $kv.value )
      | if $r < .sum then .key else empty end)
    // $default;

# build 5 random sentences
def sentences:
  pairsAndTriples(words) as $library
  | range(1;6) as $u
  # First word:
  | { prng: (seed((now + $u) % D) | nextFloat)}
  | .prng.nextFloat as $nf
  | .sentence = ($library.dict["."] | weightedRandomChoice($nf))
  | .lastOne = .sentence
  | .lastTwo = ". " + .sentence
  | until(.break;
      $library.dict3[.lastTwo] as $x
      | if $x
        then .prng |= nextFloat
        | (.prng.nextFloat) as $nf
        | ($x | weightedRandomChoice($nf)) as $nextOne
        | .sentence += " " + $nextOne
        # stop on reaching ending punctuation
        | if any(ending|split("")[]; . as $punctuation | $nextOne | index($punctuation))
          then .break = true
          else .lastTwo = .lastOne + " " + $nextOne
          | .lastOne = $nextOne
          end
        else debug("unexpected failure") | .break=true
        end )
    # tidy up sentence
    | .sentence
    | reduce (ending + pausing | split("")[]) as $p (.; . |= gsub(" [\($p)]"; "\($p)") )
    | if startswith("“") and (test("”")|not) then .sentence += "”" end ;

sentences
