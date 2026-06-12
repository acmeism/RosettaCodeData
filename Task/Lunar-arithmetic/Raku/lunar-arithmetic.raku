# The operators
sub infix:<🌙+> ($a, $b = 0) { # addition
    +([Zmax] ('0'x$b.chars~$a).comb,('0'x$a.chars~$b).comb).join;
}

sub infix:<🌙×> ($a, $b = 9) { # multiplication
    [🌙+] $b.flip.comb.kv.map: -> $k,$v {$a.comb.map(* min $v).join ~ '0'x$k}
}

# The task
for (976, 348), (23, 321), (232, 35), (123, 32192, 415, 8) {
    say '     Lunar add: ' ~ (.join: ' 🌙+ ') ~ ' == ' ~ (.join: ' 🌙+ ').EVAL;
    say 'Lunar multiply: ' ~ (.join: ' 🌙× ') ~ ' == ' ~ (.join: ' 🌙× ').EVAL;
    say '';
}

say "First 20 distinct lunar even numbers:\n" ~ (^Inf).map(* 🌙× 2).unique[^20];
say "\nFirst 20 lunar square numbers:\n"      ~ (my @squares = (^Inf).map:{$_ 🌙× $_})[^20];
say "\nFirst 20 lunar factorial numbers:\n"   ~ (1..*).map({[🌙×] 1..$_})[^20];

# Stretch
say "\nFirst number whose lunar square is smaller than the previous: " ~
(1..Inf).first: {@squares[$_ - 1] > @squares[$_]};
