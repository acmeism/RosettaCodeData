my @abc = 'a' .. 'z';
my @symb = ' ', |@abc;  # modified Baconian charset - space and full alphabet
# TODO original one with I=J U=V, nice for Latin

my %bacon = @symb Z=> (^@symb).map(*.base(2).fmt("%05s"));
my %nocab = %bacon.antipairs;

sub bacon ($s, $msg) {
  my @raw = $s.lc.comb;
  my @txt := @raw[ (^@raw).grep({@raw[$_] (elem) @abc}) ];
  for $msg.lc.comb Z @txt.batch(5) -> ($c-msg, @a) {
    for @a.kv -> $i, $c-str {
      (my $x := @a[$i]) = $x.uc if %bacon{$c-msg}.comb[$i].Int.Bool;
  } }
  @raw.join;
}

sub unbacon ($s) {
  my $chunks = ($s ~~ m:g/\w+/)>>.Str.join.comb(/.**5/);
  $chunks.map(*.comb.map({.uc eq $_})».Int».Str.join).map({%nocab{$_}}).join;
}

my $msg = "Omnes homines dignitate et iure liberi et pares nascuntur";

my $str = <Lorem ipsum dolor sit amet, consectetur adipiscing elit,
sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi
ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit
in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
Excepteur sint occaecat cupidatat non proident, sunt in culpa
qui officia deserunt mollit anim id est laborum.>;

my $baconed = bacon $str, $msg;
$baconed = $baconed.?naive-word-wrapper || $baconed;
# FIXME ^^^ makes dbl space after .
say "text:\n$baconed\n";
my $unbaconed = unbacon($baconed).trim.uc;
say "hidden message:\n$unbaconed";
