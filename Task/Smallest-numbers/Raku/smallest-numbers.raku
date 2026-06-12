sub smallest ( $n ) {
    state  @powers = '', |map { $_ ** $_ }, 1 .. *;

    return @powers.first: :k, *.contains($n);
}

.say for (^51).map(&smallest).batch(10)».fmt('%2d');
