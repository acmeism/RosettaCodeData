my %opnames = <
    Less   lt     LessEqual    le     Multiply mul    Subtract sub    NotEqual ne
    Divide div    GreaterEqual ge     Equal    eq     Greater  gt     Negate   neg
>;

my (@AST, %strings, %names);
my $string-count = my $name-count = my $pairsym = my $pc = 0;

sub tree {
    my ($A, $B) = ( '_' ~ ++$pairsym, '_' ~ ++$pairsym );
    my $line = @AST.shift // return '';
    $line ~~ /^ $<instr> = (\w+|';') [\s+ $<arg> =(.*)]? / or die "bad input $line";
    given $<instr> {
        when 'Identifier' { "fetch [{%names{$<arg>} //= $name-count++ }]\n" }
        when 'Sequence'   { tree() ~ tree() }
        when 'Integer'    { "push  $<arg>\n" }
        when 'String'     { "push  { %strings{$<arg>} //= $string-count++ }\n" }
        when 'Assign'     { join '', reverse (tree().subst( /fetch/, 'store')), tree() }
        when 'While'      { "$A:\n{ tree() }jz    $B\n{ tree() }jmp   $A\n$B:\n" }
        when 'If'         { tree() ~ "jz    $A\n{ !@AST.shift ~ tree() }jmp   $B\n$A:\n{ tree() }$B:\n" }
        when ';'          { '' }
        default           { tree() ~ tree() ~ (%opnames{$<instr>} // $<instr>.lc) ~ "\n" }
    }
}

@AST = slurp('ast.txt').lines;
my $code = tree() ~ "halt\n";

$code ~~ s:g/^^ jmp \s+ (\S+) \n ('_'\d+:\n) $0:\n/$1/;                                          # remove jmp next
$code ~~ s:g/^^ (<[a..z]>\w* (\N+)? ) $$/{my $l=$pc.fmt("%4d "); $pc += $0[0] ?? 5 !! 1; $l}$0/; # add locations
my %labels = ($code ~~ m:g/^^ ('_' \d+) ':' \n \s* (\d+)/)».Slip».Str;                           # pc addr of labels
$code ~~ s:g/^^ \s* (\d+) \s j[z|mp] \s* <(('_'\d+)/ ({%labels{$1} - $0 - 1}) %labels{$1}/;      # fix jumps
$code ~~ s:g/^^ '_'\d+.*?\n//;                                                                   # remove labels

say "Datasize: $name-count Strings: $string-count\n"
   ~ join('', %strings.keys.sort.reverse «~» "\n")
   ~ $code;
