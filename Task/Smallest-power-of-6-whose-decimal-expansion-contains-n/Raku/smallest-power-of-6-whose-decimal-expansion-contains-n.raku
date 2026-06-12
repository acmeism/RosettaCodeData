use Lingua::EN::Numbers;

my @po6 = ^Inf .map: *.exp: 6;

put join "\n", (flat ^22, 120).map: -> $n {
    sprintf "%3d: 6%-4s %s", $n, .&super, comma @po6[$_]
    given @po6.first: *.contains($n), :k
};
