use Test;

sub palin( Str $string) { so $string.lc.comb(/\w/) eq  $string.flip.lc.comb(/\w/) }

for
    'A man, a plan, a canal: Panama.'           => True,
    'My dog has fleas'                          => False,
    "Madam, I'm Adam."                          => True,
    '1 on 1'                                    => False,
    'In girum imus nocte et consumimur igni'    => True,
    ''                                          => True
{
  my ($test, $expected-result) = .kv;
    is palin($test), $expected-result,
        "\"$test\" is {$expected-result??''!!'not '}a palindrome.";
}

done-testing;
