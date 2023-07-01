use strict;
use warnings;
use Unicode::UCD 'charinfo';

for (
  ['', ' '],
  ['"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln ', '-'],
  ['..1111111111111111111111111111111111111111111111111111111111111117777888', '7'],
  ["I never give 'em hell, I just tell the truth, and they think it's hell. ", '.'],
  ['                                                    --- Harry S Truman  ', ' '],
  ['                                                    --- Harry S Truman  ', '-'],
  ['                                                    --- Harry S Truman  ', 'r']
) {
    my($phrase,$char) = @$_;
    (my $squeeze = $phrase) =~ s/([$char])\1+/$1/g;
    printf "\nOriginal length: %d <<<%s>>>\nSqueezable on \"%s\": %s\nSqueezed length: %d <<<%s>>>\n",
        length($phrase), $phrase,
        charinfo(ord $char)->{'name'},
        $phrase ne $squeeze ? 'True' : 'False',
        length($squeeze), $squeeze
}
