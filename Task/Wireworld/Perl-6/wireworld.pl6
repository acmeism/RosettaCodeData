class Wireworld {
    has @.line;

    multi method new(@line) { self.new: :@line }
    multi method new($str ) { self.new: $str.split: "\n" }

    method gist { join "\n", @.line }
    method postcircumfix:<[ ]>($i) { @.line[$i].comb }

    method neighbors($i where ^@.line, $j where ^$.line.pick.chars)
    {
        my @i = grep any(^@.line), $i «+« (-1, 0, 1);
        my @j = grep any(^@.line.pick.chars), $j «+« (-1, 0, 1);
        gather for @i X @j -> \i, \j {
            next if [ i, j ] ~~ [ $i, $j ];
            take self[i][j];
        }
    }
    method succ {
        my $succ = self.new: '' xx @.line;
        for ^@.line X ^@.line.pick.chars -> $i, $j {
            $succ.line[$i] ~=
            do given self[$i][$j] {
                when 'H' { 't' }
                when 't' { '.' }
                when '.' {
                    grep('H', self.neighbors($i, $j)) == 1|2 ?? 'H' !! '.'
                }
                default { ' ' }
            }
        }
        return $succ;
    }
}

my $str =
"tH.........
.   .
   ...
.   .
Ht.. ......";

my Wireworld $world .= new: $str;
say $world++ for ^3;
