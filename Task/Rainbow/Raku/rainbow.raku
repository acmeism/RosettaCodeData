use Color::Names:api<2>;
use Color::Names::X11 :colors;

for 'RAINBOW',
    'Another phrase that happens to contain the word "Rainbow".'
  -> $rainbow-text {
    for $rainbow-text.comb Z, flat(<red orange yellow green blue indigo violet> xx *) -> ($l, $c) {
        print "\e[38;2;{COLORS{"{$c}-X11"}<rgb>.join(';')}m$l\e[0"
    }
    say '';
}
