my @lines =
q|Given$a$text$file$of$many$lines,$where$fields$within$a$line$
are$delineated$by$a$single$'dollar'$character,$write$a$program
that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
column$are$separated$by$at$least$one$space.
Further,$allow$for$each$word$in$a$column$to$be$either$left$
justified,$right$justified,$or$center$justified$within$its$column.
|.lines;

my @widths;

for @lines { for .split('$').kv { @widths[$^key] max= $^word.chars; } }
for @lines { say |.split('$').kv.map: { (align @widths[$^key], $^word) ~ " "; } }

sub align($column_width, $word, $aligment = @*ARGS[0]) {
        my $lr = $column_width - $word.chars;
        my $c  = $lr / 2;
        given ($aligment) {
                when "center" { " " x $c.ceiling ~ $word ~ " " x $c.floor }
                when "right"  { " " x $lr        ~ $word                  }
                default       {                    $word ~ " " x $lr      }
        }
}
