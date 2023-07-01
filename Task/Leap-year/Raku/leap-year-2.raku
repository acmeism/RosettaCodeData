multi method is-leap-year($y = $!year) {
    $y %% 4 and not $y %% 100 or $y %% 400
}
