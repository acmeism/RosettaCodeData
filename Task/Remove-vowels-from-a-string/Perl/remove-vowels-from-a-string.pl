use strict;
use warnings;
use utf8;
binmode STDOUT, ":utf8";
use Unicode::Normalize;

my $text = <<~'END';
    Norwegian, Icelandic, German, Turkish, French, Spanish, English:
    Undervisningen skal være gratis, i det minste på de elementære og grunnleggende trinn.
    Skal hún veitt ókeypis, að minnsta kosti barnafræðsla og undirstöðummentu.
    Hochschulunterricht muß allen gleichermaßen entsprechend ihren Fähigkeiten offenstehen.
    Öğrenim hiç olmazsa ilk ve temel safhalarında parasızdır. İlk öğretim mecburidir.
    L'éducation doit être gratuite, au moins en ce qui concerne l'enseignement élémentaire et fondamental.
    La instrucción elemental será obligatoria. La instrucción técnica y profesional habrá de ser generalizada.
    Education shall be free, at least in the elementary and fundamental stages.
    END

my @vowels;
chr($_) =~ /[aæeiıoœu]/i and push @vowels, chr($_) for 0x20 .. 0x1ff;
print NFD($_) =~ /@{[join '|', @vowels]}/ ? ' ' : $_ for split /(\X)/, $text;
