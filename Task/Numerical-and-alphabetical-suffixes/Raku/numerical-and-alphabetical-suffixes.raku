use Rat::Precise;

my $googol = 10**100;
«PAIRs 2 SCOres 20 DOZens 12 GRoss 144  GREATGRoss 1728 GOOGOLs $googol»
  ~~ m:g/ ((<.:Lu>+) <.:Ll>*) \s+ (\S+) /;

my %abr = |$/.map: {
    my $abbrv = .[0].Str.fc;
    my $mag   = +.[1];
    |map { $abbrv.substr( 0, $_ ) => $mag },
    .[0][0].Str.chars .. $abbrv.chars
}

my %suffix = flat %abr,
(<K  M  G  T  P  E  Z  Y  X  W  V  U>».fc  Z=> (1000, * * 1000 … *)),
(<Ki Mi Gi Ti Pi Ei Zi Yi Xi Wi Vi Ui>».fc Z=> (1024, * * 1024 … *));

my $reg = %suffix.keys.join('|');

sub comma ($i is copy) {
    my $s = $i < 0 ?? '-' !! '';
    my ($whole, $frac) = $i.split('.');
    $frac = $frac.defined ?? ".$frac" !! '';
    $s ~ $whole.abs.flip.comb(3).join(',').flip ~ $frac
}

sub units (Str $str) {
    $str.fc ~~ /^(.+?)(<alpha>*)('!'*)$/;
    my ($val, $unit, $fact) = $0, $1.Str.fc, $2.Str;
    $val.=subst(',', '', :g);
    if $val ~~ m:i/'e'/ {
        my ($m,$e) = $val.split(/<[eE]>/);
        $val = ($e < 0)
            ?? $m * FatRat.new(1,10**-$e)
            !! $m * 10**$e;
    }
    my @suf = $unit;
    unless %suffix{$unit}:exists {
        $unit ~~ /(<$reg>)+/;
        @suf = $0;
    }
    my $ret = $val<>;
    $ret = [*] $ret, |@suf.map: { %suffix{$_} } if @suf[0];
    $ret = [*] ($ret, * - $fact.chars …^ * < 2) if $fact.chars;
    $ret.?precise // $ret
}

my $test = q:to '===';
2greatGRo   24Gros  288Doz  1,728pairs  172.8SCOre
1,567      +1.567k    0.1567e-2m
25.123kK    25.123m   2.5123e-00002G
25.123kiKI  25.123Mi  2.5123e-00002Gi  +.25123E-7Ei
-.25123e-34Vikki      2e-77gooGols
9!   9!!   9!!!   9!!!!   9!!!!!   9!!!!!!   9!!!!!!!   9!!!!!!!!   9!!!!!!!!!
.017k!!
===

printf "%16s: %s\n", $_, comma .&units for $test.words;

# Task required stupid layout
# say "\n In: $_\nOut: ", .words.map({comma .&units}).join('  ') for $test.lines;
