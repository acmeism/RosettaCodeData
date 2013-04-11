my $url = "http%3A%2F%2Ffoo%20bar%2F";

say $url.subst: :g,
    /'%'(<:hexdigit>**2)/,
    ->  ($ord          ) { chr(:16(~$ord)) }
