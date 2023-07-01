sub glyph ($_) {
    when * < 33 { (0x2400 + $_).chr } # display symbol names for invisible glyphs
    when 127    { '␡' }
    default     { .chr }
}

say '{|class="wikitable" style="text-align:center;background-color:hsl(39, 90%, 95%)"';

for (^128).rotor(16) -> @row {
    say '|-';
    printf(q[|%d<br>0x%02X<br><big><big title="%s">%s</big></big>] ~ "\n",
      $_, $_, .&glyph.uniname.subst('SYMBOL FOR ', ''),
      .&glyph.subst('|', '<nowiki>|</nowiki>')) for @row;
}

say '|}';
