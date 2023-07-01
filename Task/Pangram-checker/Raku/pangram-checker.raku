constant Eng = set 'a' .. 'z';
constant Cyr = (set 'а' .. 'ё') (-) (set 'ъ', 'ѐ');
constant Hex = set 'a' .. 'f';

sub pangram($str, Set $alpha = Eng) {
  $alpha ⊆ $str.lc.comb
}

say pangram("The quick brown fox jumps over the lazy dog.");
say pangram("My dog has fleas.");
say pangram("My dog has fleas.", Hex);
say pangram("My dog backs fleas.", Hex);
say pangram "Съешь же ещё этих мягких французских булок, да выпей чаю", Cyr;
