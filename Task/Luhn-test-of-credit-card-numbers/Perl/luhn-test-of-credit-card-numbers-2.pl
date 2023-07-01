sub luhn {
    my (@n,$i,$sum) = split //, reverse $_[0];
    my @a = map {int(2*$_ / 10) + (2*$_ % 10)} (0..9);
    map {$sum += $i++ % 2 ? $a[$_] : $_} @n;
    return ($sum % 10) ? 0 : 1;
}

# Test and display
map {print luhn($_), ": $_\n"}
    qw(49927398716 49927398717 1234567812345678 1234567812345670);
