use charnames ':full';
binmode STDOUT, ':utf8';

sub glyph {
    my($n) = @_;
    if    ($n < 33) { chr 0x2400 + $n } # display symbol names for invisible glyphs
    elsif ($n==124) { '<nowiki>|</nowiki>' }
    elsif ($n==127) { 'DEL' }
    else            { chr $n }
}

print qq[{|class="wikitable" style="text-align:center;background-color:hsl(39, 90%, 95%)"\n];

for (0..127) {
    print qq[|-\n] unless $_ % 16;;
        printf qq[|%d<br>0x%02X<br><big><big title="%s">%s</big></big>\n],
                $_, $_, charnames::viacode($_), glyph($_);
    }
}
print qq[|}\n];
