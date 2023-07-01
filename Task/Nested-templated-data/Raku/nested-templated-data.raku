say join "\n  ", '##PAYLOADS:', |my @payloads = 'Payload#' X~ ^7;

for [
     (((1, 2),
       (3, 4, 1),
       5),),

     (((1, 2),
       (10, 4, 1),
       5),)
    ] {
    say "\n      Template: ", $_.raku;
    say "Data structure: { @payloads[|$_].raku }";
}
