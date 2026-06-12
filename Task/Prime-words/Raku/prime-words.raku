my @words = 'unixdict.txt'.IO.words».fc;

sub display ($n, @n, $s = "First 20: ") {"$n;\n{$s}{@n.join: ', '}"}

# The task
say 'Number of words whose ords are all prime: ',
    @words.hyper.grep({ .ords.all.is-prime }).&{display +$_, $_, ''};

# Twelve other minor variants
say "\nNumber of words whose ordinal sum is prime: ",
    @words.grep({ .ords.sum.is-prime }).&{display +$_, .head(20)};

say "\nNumber of words whose ords are all prime, and whose ordinal sum is prime: ",
    @words.hyper.grep({ .ords.all.is-prime && .ords.sum.is-prime }).&{display +$_, $_, ''};

say "\n\nInterpreting the words as if they were base 36 numbers:";

say "\nNumber of words whose 'digits' are all prime in base 36: ",
    @words.hyper.grep({ !.contains(/\W/) && all(.comb».parse-base(36)).is-prime }).&{display +$_, $_, ''};

say "\nNumber of words that are prime in base 36: ",
    @words.grep({ !.contains(/\W/) && :36($_).is-prime }).&{display +$_, .head(20)};

say "\nNumber of words whose base 36 digital sum is prime: ",
    @words.grep({ !.contains(/\W/) && .comb».parse-base(36).sum.is-prime }).&{display +$_, .head(20)};

say "\nNumber of words that are prime in base 36, and whose digital sum is prime: ",
    @words.grep({ !.contains(/\W/) && :36($_).is-prime && .comb».parse-base(36).sum.is-prime }).&{display +$_, .head(20)};

say "\nNumber of words that are prime in base 36, whose digits are all prime, and whose digital sum is prime: ",
    @words.hyper.grep({ !.contains(/\W/) && all(.comb».parse-base(36)).is-prime && :36($_).is-prime && .comb».parse-base(36).sum.is-prime }).&{display +$_, $_, ''};

use Base::Any:ver<0.1.2+>;
set-digits('a'..'z');

say "\n\nTests using a custom base 26 where 'a' through 'z' is 0 through 25 and words are case folded:";

say "\nNumber of words whose 'digits' are all prime using a custom base 26: ",
    @words.hyper.grep({ !.contains(/<-alpha>/) && all(.comb».&from-base(26)).is-prime }).&{display +$_, $_, ''};

say "\nNumber of words that are prime using a custom base 26: ",
    @words.grep({ !.contains(/<-alpha>/) && .&from-base(26).is-prime }).&{display +$_, .head(20)};

say "\nNumber of words whose digital sum is prime using a custom base 26: ",
    @words.grep({ !.contains(/<-alpha>/) && .comb».&from-base(26).sum.is-prime }).&{display +$_, .head(20)};

say "\nNumber of words that are prime in a custom base 26 and whose digital sum is prime in that base: ",
    @words.grep({ !.contains(/<-alpha>/) && .&from-base(26).is-prime && .comb».&from-base(26).sum.is-prime }).&{display +$_, .head(20)};

say "\nNumber of words that are prime in custom base 26, whose digits are all prime, and whose digital sum is prime: ",
    @words.hyper.grep({ !.contains(/<-alpha>/) && all(.comb».&from-base(26)).is-prime && .&from-base(26).is-prime && .comb».&from-base(26).sum.is-prime }).&{display +$_, $_, ''};
