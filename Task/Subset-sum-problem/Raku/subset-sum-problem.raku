my @pairs =
    alliance => -624, archbishop => -915, balm => 397, bonnet => 452,
    brute => 870, centipede => -658, cobol => 362, covariate => 590,
    departure => 952, deploy => 44, diophantine => 645, efferent => 54,
    elysee => -326, eradicate => 376, escritoire => 856, exorcism => -983,
    fiat => 170, filmy => -874, flatworm => 503, gestapo => 915,
    infra => -847, isis => -982, lindholm => 999, markham => 475,
    mincemeat => -880, moresby => 756, mycenae => 183, plugging => -266,
    smokescreen => 423, speakeasy => -745, vein => 813;
my @weights = @pairs».value;
my %name = @pairs.hash.invert;

.say for (1..27).hyper(:3batch).map: -> $n {
    given @weights.combinations($n).first({ 0 == [+] @^comb }) {
        when .so { "Length $n: ({.map: {%name{$_}}})" }
        default  { "Length $n: (none)" }
    }
}
