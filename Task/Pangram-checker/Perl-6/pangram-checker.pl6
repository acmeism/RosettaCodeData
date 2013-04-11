constant Eng = set 'a' .. 'z';
constant Cyr = set <а б в г д е ж з и й к л м н о п р с т у ф х ц ч ш щ ъ ы ь э ю я ё>;
constant Hex = set 'a' .. 'f';

sub pangram($str, Set $alpha = Eng) {
  $alpha ⊆ $str.lc.comb;
}

say pangram("The quick brown fox jumps over the lazy dog.");
say pangram("My dog has fleas.");
say pangram("My dog has fleas.", Hex);
say pangram("My dog backs fleas.", Hex);
say pangram "Съешь же ещё этих мягких французских булок, да выпей чаю", Cyr;
