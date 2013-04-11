my @lines = slurp("example.txt").lines;
my @widths;

for @lines { for .split('$').kv { @widths[$^key] max= $^word.chars; } }
for @lines { say .split('$').kv.map: { (align @widths[$^key], $^word) ~ " "; } }

sub align($column_width, $word, $aligment = @*ARGS[0]) {
        my $lr = $column_width - $word.chars;
        my $c  = $lr / 2;
        given ($aligment) {
                when "center" { " " x $c.ceiling ~ $word ~ " " x $c.floor }
                when "right"  { " " x $lr        ~ $word                  }
                default       {                    $word ~ " " x $lr      }
        }
}
