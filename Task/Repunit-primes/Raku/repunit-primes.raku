my $limit = 2700;

say "Repunit prime digits (up to $limit) in:";

.put for (2..16).hyper(:1batch).map: -> $base {
    $base.fmt("Base %2d: ") ~ (1..$limit).grep(&is-prime).grep( (1 x *).parse-base($base).is-prime )
}
