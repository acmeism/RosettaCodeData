my $url = "http%3A%2F%2Ffoo%20bar%2F";

say $url.subst: :g,
    /'%'(<:hexdigit>**2)/,
    ->  ($ord          ) { chr(:16(~$ord)) }

# Alternately, you can use an in-place substitution:
$url ~~ s:g[ '%' (<:hexdigit> ** 2) ] = chr :16(~$0);
say $url;
