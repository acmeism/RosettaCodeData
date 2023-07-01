sub fizz_buzz {
    join("\n", map {
        sub mult {$_ % shift == 0};
        my @out;
        if (mult 3) { push @out, "Fizz"; }
        if (mult 5) { push @out, "Buzz"; }
        if (!@out) {push @out, $_; }
        join('', @out);
    } (1..100))."\n";
}
print fizz_buzz;
