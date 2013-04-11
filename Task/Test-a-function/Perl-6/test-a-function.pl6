use Test;

my %tests =
    'A man, a plan, a canal: Panama.'           => True,
    'My dog has fleas'                          => False,
    "Madam, I'm Adam."                          => True,
    '1 on 1'                                    => False,
    'In girum imus nocte et consumimur igni'    => True,
    ''                                          => True,
    ;

plan %tests.elems;

for %tests.kv -> $test, $expected-result {
    is palin($test), $expected-result,
        "\"$test\" is {$expected-result??''!!'not '}a palindrome.";
}
