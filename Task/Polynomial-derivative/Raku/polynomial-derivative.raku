use Lingua::EN::Numbers:ver<2.8+>;

sub pretty (@poly) {
    join( '+', (^@poly).reverse.map: { @poly[$_] ~ "x{.&super}" } )\
    .subst(/['+'|'-']'0x'<[⁰¹²³⁴⁵⁶⁷⁸⁹]>*/, '', :g).subst(/'x¹'<?before <-[⁰¹²³⁴⁵⁶⁷⁸⁹]>>/, 'x')\
    .subst(/'x⁰'$/, '').subst(/'+-'/, '-', :g).subst(/(['+'|'-'|^])'1x'/, {"$0x"}, :g) || 0
}

for [5], [4,-3], [-1,3,-2,1], [-1,6,5], [1,1,0,-1,-1] -> $test {
   say "Polynomial: " ~ "[{$test.join: ','}] ➡ " ~ pretty $test;
   my @poly = |$test;
   (^@poly).map: { @poly[$_] *= $_ };
   shift @poly;
   say "Derivative: " ~ "[{@poly.join: ','}] ➡ " ~ pretty @poly;
   say '';
}
