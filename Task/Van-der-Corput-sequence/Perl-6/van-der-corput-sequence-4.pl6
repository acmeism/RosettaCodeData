sub vdc($value, $base = 2) {
    my @values := $value, { $_ div $base } ... 0;
    my @denoms := $base,  { $_  *  $base } ... *;
    [+] do for @values Z @denoms -> $v, $d {
        $v mod $base / $d;
    }
}
