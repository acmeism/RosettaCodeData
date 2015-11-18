my $s = Q :array :to 'EOH';
    123 \n '"`
        @a$bc
        @a[]
    EOH

dd $s; # OUTPUT«Str $var = "123 \\n '\"`\n    \@a\$bc\n    1 2 3 4\n"»
