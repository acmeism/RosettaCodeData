my @vowels = (0x20 .. 0x2fff).map: { .chr if .chr.samemark('x') ~~ m:i/<[aæeiıoœu]>/ }

my $text = q:to/END/;
   Norwegian, Icelandic, German, Turkish, French, Spanish, English:
   Undervisningen skal være gratis, i det minste på de elementære og grunnleggende trinn.
   Skal hún veitt ókeypis, að minnsta kosti barnafræðsla og undirstöðummentu.
   Hochschulunterricht muß allen gleichermaßen entsprechend ihren Fähigkeiten offenstehen.
   Öğrenim hiç olmazsa ilk ve temel safhalarında parasızdır. İlk öğretim mecburidir.
   L'éducation doit être gratuite, au moins en ce qui concerne l'enseignement élémentaire et fondamental.
   La instrucción elemental será obligatoria. La instrucción técnica y profesional habrá de ser generalizada.
   Education shall be free, at least in the elementary and fundamental stages.
   END

put $text.subst(/@vowels/, ' ', :g);
