# 20260601 Raku programming solution

my token word { <:Letter>+ [ "'" <:Letter>+ ]* }

sub is-vowel(Str $c --> Bool) { so $c.lc eq any <a e i o u> }

sub first-vowel-pos(Str $w --> Int) {
   my @ch = $w.comb;
   for @ch.kv -> $i, $ch {
      # Initial y is treated as a consonant
      if $ch.lc eq 'y' { $i > 0 ?? return $i !! next }
      if is-vowel($ch) {
         # handle "qu" as part of the initial consonant cluster
         $ch.lc eq 'u' && $i > 0 && @ch[$i-1].lc eq 'q' ?? ( next ) !! return $i
      }
   }
   return -1
}

sub pig-word(Str $w --> Str) {
   my ($all-caps, $init-cap) = $w Xeq $w.uc, $w.tc;
   my $suffix    = $all-caps ?? 'AY'  !! 'ay';
   my $v-suffix  = $all-caps ?? 'WAY' !! 'way';

   my $pos = first-vowel-pos($w);

   if $pos < 0 { return $w ~ $suffix } # No usable vowel: append ay/AY directly

   if $pos == 0 { return $w ~ $v-suffix } # Starts with vowel

   my ($head, $tail) = do given $w { .substr(0, $pos), .substr($pos) }

   # For capitalised words, move the consonant cluster to the end
   # in lowercase, then capitalise the new first letter.
   if $init-cap && !$all-caps { return ($tail ~ $head.lc ~ $suffix).tc }

   return $tail ~ $head ~ $suffix
}

sub pig-latin(Str $text --> Str) {
   $text.subst( :g, / $<w>=<&word> $<digits>=\d* /, -> $/ {
      pig-word(~$<w>) ~ ~$<digits> // ''
   })
}

for
   ""                                , "",
   " "                               , " ",
   "123456!"                         , "123456!",
   "Stop! In the name of Wuv!"       , "Opstay! Inway ethay amenay ofway Uvway!",
   "My word!"                        , "Ymay ordway!",
   "ESA JAXA NASA"                   , "ESAWAY AXAJAY ASANAY",
   "this is 'quoted'"                , "isthay isway 'otedquay'",
   "MgClBr (Na,K)AlSiO4"             , "MgClBray (Anay,KAY)AlSiOway4",
   "pig  latin"                      , "igpay  atinlay",
   "rosetta  code"                   , "osettaray  odecay",
   "the quick brown fox jumps over the lazy dog"
                                     , "ethay ickquay ownbray oxfay umpsjay overway ethay azylay ogday",
   "The Quick Brown Fox Jumps Over The Lazy Dog"
                                     , "Ethay Ickquay Ownbray Oxfay Umpsjay Overway Ethay Azylay Ogday",
   "by the way"                      , "ybay ethay ayway",
   "ytterbium"                       , "erbiumyttay",
   "banana"                          , "ananabay",
   "BaNaNa"                          , "ANaNabay",
   "bAnAnA"                          , "AnAnAbay",
   "BANANA"                          , "ANANABAY",
   "pig"                             , "igpay",
   "black"                           , "ackblay",
   "a"                               , "away",
   "open"                            , "openway",
   "hello world"                     , "ellohay orldway",
   "Hello, World!"                   , "Ellohay, Orldway!",
   "o'hare O'HARE o'hare don't"      , "o'hareway O'HAREWAY o'hareway on'tday"
-> $input, $expected {
   say ( my $actual = pig-latin($input) ) eq $expected
      ?? "ok     [$input] -> [$actual]"
      !! "not ok [$input]\n       got: [$actual]\n  expected: [$expected]";
}
