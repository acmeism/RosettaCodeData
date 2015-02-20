multi can-spell-word(Str $word, @blocks) {
    my @regex = @blocks.map({ EVAL "/{.comb.join('|')}/" }).grep: { .ACCEPTS($word.uc) }
    can-spell-word $word.uc.comb, @regex;
}

multi can-spell-word([$head,*@tail], @regex) {
    for @regex -> $re {
        if $head ~~ $re {
            return True unless @tail;
            return False if @regex == 1;
            return True if can-spell-word @tail, @regex.grep: * !=== $re;
        }
    }
    False;
}

my @b = <BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM>;

for <A BaRK BOoK tREaT COmMOn SqUAD CoNfuSE> {
    say "$_     &can-spell-word($_, @b)";
}
