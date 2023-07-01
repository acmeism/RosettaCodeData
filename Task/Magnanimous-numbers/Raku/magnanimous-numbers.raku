my @magnanimous = lazy flat ^10, (10 .. 1001).map( {
    my int $last;
    (1 ..^ .chars).map: -> \c { $last = 1 and last unless (.substr(0,c) + .substr(c)).is-prime }
    next if $last;
    $_
} ),

(1002 .. ∞).map: {
     # optimization for numbers > 1001; First and last digit can not both be even or both be odd
    next if (.substr(0,1) + .substr(*-1)) %% 2;
    my int $last;
    (1 ..^ .chars).map: -> \c { $last = 1 and last unless (.substr(0,c) + .substr(c)).is-prime }
    next if $last;
    $_
}

put 'First 45 magnanimous numbers';
put @magnanimous[^45]».fmt('%3d').batch(15).join: "\n";

put "\n241st through 250th magnanimous numbers";
put @magnanimous[240..249];

put "\n391st through 400th magnanimous numbers";
put @magnanimous[390..399];
