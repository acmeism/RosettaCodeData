use Lingua::EN::Numbers;

my @cyclops = 0, |flat lazy ^∞ .map: -> $exp {
      my @oom = (exp($exp, 10) ..^ exp($exp + 1, 10)).grep: { !.contains: 0 }
      |@oom.hyper.map: { $_ ~ 0 «~« @oom }
}

my @prime-cyclops = @cyclops.grep: { .is-prime };

for '',                   @cyclops,
    'prime ',             @prime-cyclops,
    'blind prime ',       @prime-cyclops.grep( { .trans('0' => '').is-prime } ),
    'palindromic prime ', @prime-cyclops.grep( { $_ eq .flip } )
  -> $type, $iterator {
    say "\n\nFirst 50 {$type}cyclops numbers:\n" ~ $iterator[^50].batch(10)».fmt("%7d").join("\n") ~
        "\n\nFirst {$type}cyclops number > 10,000,000: " ~ comma($iterator.first: * > 1e7 ) ~
        " - at (zero based) index: " ~ comma $iterator.first: * > 1e7, :k;
}
